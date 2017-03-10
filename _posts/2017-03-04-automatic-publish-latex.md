---
layout: post
title:  "Publishing LaTeX PDFs using Travis CI"
date:   2017-03-04 12:30:00
---

## Background

[LaTeX](https://en.wikipedia.org/wiki/LaTeX) is a typesetting application that consumes documents written in the LaTeX format and can generate beautiful PDF documents. It's used regularly in academia, but can be used in any field. I use it all the time because I like to version control my documents and I find the syntax easier than standard word processors to work with.

This guide assumes:

- you have a working knowledge of [git](https://en.wikipedia.org/wiki/Git) and [LaTeX](https://en.wikipedia.org/wiki/LaTeX)
- you have a [GitHub](https://github.com/) account
- your project is eligible to published publicly
- you are going to publish into an [AWS S3](https://aws.amazon.com/s3/) bucket
- you have the ability to make new [AWS IAM](https://aws.amazon.com/iam/) users

### Example Repository

All the code discussed in this guide is online for reference. The repository is connected to Travis CI, and publishes to S3.

- GitHub is [github.com/mide/sample-latex-project](https://github.com/mide/sample-latex-project)
- Travis CI Build is [travis-ci.org/mide/sample-latex-project](https://travis-ci.org/mide/sample-latex-project)
- Published PDF is [share.cranstonide.com/sample-latex-project/my-file-1.pdf](https://share.cranstonide.com/sample-latex-project/my-file-1.pdf)

## Generate AWS IAM User for Your Build

As stated above, this guide assumes you'll be publishing your PDF into an AWS S3 bucket. In order to do this, you will need to carve off a new [IAM](https://aws.amazon.com/iam/) user for this build. I recommend using a different IAM user for each build, and limit the scope of each. I like to limit my IAM users as heavily as possible, to limit the damages if anything ever gets compromised.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::us-west-2-com-cranstonide-share/sample-latex-project/my-file-1.pdf"
        }
    ]
}
```

I also apply a managed policy to deny (see [IAM Policy Evaluation Logic](http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)) high-risk operations. This is optional.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyAllNonS3Actions",
            "Effect": "Deny",
            "NotAction": "s3:*",
            "Resource": "*"
        },
        {
            "Sid": "DenyHighProfileS3Actions",
            "Effect": "Deny",
            "Action": [
                "s3:CreateBucket",
                "s3:DeleteBucket*",
                "s3:PutBucket*",
                "s3:Put*Configuration",
                "s3:ReplicateDelete",
                "s3:ReplicateObject",
                "s3:RestoreObject"
            ],
            "Resource": "*"
        }
    ]
}
```

When you generate your IAM user, you'll be given access keys (access key ID and secret access key). Keep these secret and do not add them directly to your project. We'll add them as environment variables into the configuration later.

## Prepare your Project

### Make your Project Public on GitHub

Since this guide uses [`travis-ci.org`](https://travis-ci.org/), you will need to make your project public on GitHub. If the project is not eligible to make public, look at [`travis-ci.com`](https://travis-ci.com/). It's likely that much of this guide will still apply, but I haven't tested it.

If this is the first time your project will be in git, you can simply create a new public repository, copy your LaTeX files into it and commit.

[![Rocket.Chat Logo](https://assets.mide.io/blog/2017-03-04/github-new-repo.png)](https://assets.mide.io/blog/2017-03-04/github-new-repo.png)

However, if your project is already in git and you're about to make it public, remember that the history will also become public. So if you've ever accidentally committed a secret, that will become public via the history. There are [guides available](https://help.github.com/articles/removing-sensitive-data-from-a-repository/) that discuss how to remove sensitive data from a repository. It's a good idea to rotate or revoke anything that was ever compromised, even if you hide it from future views.

### Add Configuration Files

I have used the following `.travis.yml`. I've opted to break some of the commands into scripts for better readability. Those scripts live in the `/scripts/` directory in my project. You can read more about the `.travis.yml` file in the [Travis CI docs](https://docs.travis-ci.com/). There are many options (far too many to describe here) so tweak the examples to fit your needs.

```
.travis.yml
```

```yaml
sudo: required # Needed to install LaTeX

install:
  - sudo bash scripts/install.sh

script:
  - bash scripts/build.sh

before_deploy:
  - rm -f output/*.log output/*.aux # Clean out non PDF files before uploading

deploy:
  provider: s3
  access_key_id: $AWS_KEY_ID # Use environment variables for security
  secret_access_key: $AWS_SECRET_KEY # Use environment variables for security
  bucket: us-west-2-com-cranstonide-share # Your S3 bucket
  skip_cleanup: true # Skip cleanup, or Travis will remove your .pdf files
  local_dir: output # The complete contents of this directory will be uploaded
  upload-dir: sample-latex-project # S3 bucket prefix (directory, no trailing slash)
  region: us-west-2 # S3 bucket region (I'm in us-west-2)
```

I have the following `scripts/install.sh` defined. This file is referenced by the `install` key above.

```
scripts/install.sh
```

```bash
#!/bin/bash

# Update Package Repositories
apt-get -qq update

# Install LaTeX - Install only the packages you need.
# Unused packages will only slow down your build for no
# added benefit.
sudo apt-get install -y --no-install-recommends \
  texlive-latex-recommended
```

I have the following `scripts/build.sh` defined. The file is referenced by the `script` key above.

```
scripts/build.sh
```

```bash
#!/bin/bash

mkdir -p output/

pdflatex -interaction=nonstopmode -halt-on-error -output-directory output "my-file-1.tex"
```

## Setting up Travis CI

### Create a Travis CI Account

Travis CI uses [OAuth](https://en.wikipedia.org/wiki/OAuth) to log in with your GitHub account, which will grant Travis CI access to some of your information. If you belong to any organizations, you may be prompted to authorize for them too. If you're unsure of whether you should, reach out to the organization owner.

[![Travis CI Create Account](https://assets.mide.io/blog/2017-03-04/travis-create-new-account.png)](https://assets.mide.io/blog/2017-03-04/travis-create-new-account.png)

### Configure the Repository / Build

Once you have created your account, you'll need to tell Travis CI what repositories you'd like to build. Flip the switches on the projects that you want to build. In my case, I've turned on the build for `mide/sample-latex-project`.

[![Travis CI Create Account](https://assets.mide.io/blog/2017-03-04/travis-list-repositories.png)](https://assets.mide.io/blog/2017-03-04/travis-list-repositories.png)

If you don't see your repository here, it's possible that Travis CI is slightly out of date. Click _"Sync account"_ in the upper right to trigger a full refresh of your account metadata.

[![My builds](https://assets.mide.io/blog/2017-03-04/travis-my-repositories.png)](https://assets.mide.io/blog/2017-03-04/travis-my-repositories.png)


Once you see a build on the left (it will likely be gray at first), you'll be ready to proceed.

### Add the Environment Variables

Enter your Travis CI project and click "More Options" and "Settings". In the section "Environment Variables" you'll need to set the two environment variables we referenced before (`$AWS_KEY_ID` and `$AWS_SECRET_KEY`).

[![Environment Variables](https://assets.mide.io/blog/2017-03-04/travis-environment-variables.png)](https://assets.mide.io/blog/2017-03-04/travis-environment-variables.png)

The concept of [environment variables](https://en.wikipedia.org/wiki/Environment_variable) is nothing specific to AWS or Travis CI. You just need to make sure the variables you specified in `.travis.yml` match the variables you're defining in the Travis CI interface.

## Trigger the First Build

Because of the order we did things (Created the GitHub repository first), you may need to trigger a build by making a new commit. This is completely avoidable if we made the repository, linked it to Travis CI and then added the `.travis.yml`, but I think for many first time users, this complexity may be confusing.

To trigger a build, you'll need to `git commit` a change (even if it's just spacing). I've [done this before](https://github.com/mide/sample-latex-project/commit/ff8ab730430d86dcd30430c535acb2d0e566adb5) and it's [trivial to reverse](https://github.com/mide/sample-latex-project/commit/41d2b7b0c04e6f3e9972de1e255f4b99d925200a) (with `git revert`). Of course, if you're expecting to make new changes, your first change will trigger the build.

## Debugging

It's totally normal to have the build fail the first couple of times. It could be a permissions issue, a dependency issue, or even an actual LaTeX issue. It's the reader's exercise to debug their build.

Thankfully, the build log does yield a lot of helpful information. If it's a LaTeX or publishing problem, it will become immediately obvious.

[![Travis CI Debugging](https://assets.mide.io/blog/2017-03-04/travis-failed-build-log.png)](https://assets.mide.io/blog/2017-03-04/travis-failed-build-log.png)

If you get a build error like *"Oops, It looks like you tried to write to a bucket that isn't yours or doesn't exist yet. Please create the bucket before trying to write to it."*, the problem may not be the bucket. This is the error that is returned for a general permissions error. Check your IAM user and directory mappings.

## In Closing

This guide is specific to Travis CI and GitHub. You could host your code anywhere ([Beanstalk](http://beanstalkapp.com/), [Bitbucket](https://bitbucket.org/), [CodeCommit](https://aws.amazon.com/codecommit/), [GitLab](https://gitlab.com), etc) and use any build system ([Bamboo](https://www.atlassian.com/software/bamboo), [Jenkins](https://jenkins.io/), [TeamCity](https://www.jetbrains.com/teamcity/), etc) with correct tweaks.

I love using LaTeX for all sorts of documents, but I've always had a tough time distributing the PDFs to people to ensure everyone was up to date. My solution was to make a build and keep an online copy up to date for everyone to see.

If you use LaTeX, a build system may be a great addition to your workflow.
