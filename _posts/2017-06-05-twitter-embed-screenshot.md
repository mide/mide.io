---
layout: post
title:  "Embed Twitter Without Tracking"
date:   2017-06-05 07:30:00
---

## About

Twitter offers the ability to embed your timeline on your website for easy visitor interaction, but if you visit my [contact page](/contact), you'll see I opted for a slightly different method of including my tweets on my website.

## Normal Workflow

If you want to embed your timeline on your website, you'll need to add the following code to your website:

```html
<a class="twitter-timeline" href="https://twitter.com/CranstonIde">
  Tweets by CranstonIde
</a>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8">
</script>
```

Once you add those simple few lines, you'll get a nice and interactive Twitter timeline (like the screenshot shown below) on your page. It's likely you've seen this around the internet; you'll be able to scroll through recent tweets, click third party links directly, and easily see images. This is the best user experience.

![Normal Twitter Embedded Screenshot](https://assets.mide.io/blog/2017-06-05/twitter-normal-embed.png)

## The Problem

That little snippet pulls [116K of code from Twitter's website](https://platform.twitter.com/widgets.js) via JavaScript. Every visitor of a website with an embedded Twitter timeline will run this code. I personally haven't read the code nor taken the time to understand it, and I have a feeling that most people haven't  either.

Without surprise, this goes directly against my [privacy goals]({% post_url 2016-05-14-protecting-your-privacy %}) for this website by including a remote source for content.

## My Solution

I have a [daily build job](https://travis-ci.org/mide/twitter-timeline-to-png) (via TravisCI's new [Cron schedule feature](https://docs.travis-ci.com/user/cron-jobs/)) that will visit my Twitter page, take a screenshot, and upload it to AWS S3. The [TTL](https://en.wikipedia.org/wiki/Time_to_live) of the cache is set to one day, so I can then embed that image and know the tweets are at most a day out of sync. This solution may not be the best user experience, but it offers the most privacy.

[The code](https://github.com/mide/twitter-timeline-to-png) is really simple, so if this is something you're interested in, I suggest giving it a shot.

[![Twitter Screenshot](https://assets.mide.io/common/twitter/twitter-timeline.png)](https://twitter.com/cranstonide)

## Links

- [Twitter's Privacy Policy for Embedded Widgets](https://support.twitter.com/articles/20175256)
- [GitHub Project](https://github.com/mide/twitter-timeline-to-png)
- [TravisCI Build](https://travis-ci.org/mide/twitter-timeline-to-png)
- [Non-Cached Result](http://us-west-2-io-mide-assets.s3-website-us-west-2.amazonaws.com/common/twitter/twitter-timeline.png)
- [My Twitter (@cranstonide)](https://www.twitter.com/cranstonide)

## Future Thoughts

- This logic could be used to develop a local cache of just about anything. I could even keep my [ham radio license](/radio) `.PDF` in sync.
- I may also add a timestamp to the image itself, so it's a little more clear when the screenshot was taken.
- Stylizing the screenshot a little more is possible, too. I may add some overlay text explaining it's a screenshot.
