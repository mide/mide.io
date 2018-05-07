---
layout: post
title:  "Running a Rocket.Chat Server"
date:   2016-08-12 19:30:00
---

![Rocket.Chat Logo](https://assets.mide.io/blog/2016-08-12/logo-header.png)

## What is Rocket.Chat

[Rocket.Chat](https://rocket.chat) is an open source chat platform that is awesome for teams and families.

My family uses it as an extension to SMS and email; we find it easier and faster to communicate with each other. It adds some great [emoji](http://emojione.com/), can be used on [multiple devices](https://rocket.chat/download) (laptop, phone, tablet, etc), and it's much cheaper than the nearest competitors.

## Running Rocket.Chat

Rocket.Chat is not a [SaaS](https://en.wikipedia.org/wiki/Software_as_a_service) solution, therefore you'll need to run your own server (or pay someone to run one for you). I have found the easiest way is to run Rocket.Chat is with [Docker](https://www.docker.com/). Docker Hub even has an [official Rocket.Chat image](https://hub.docker.com/_/rocket.chat/), so you can download stable versions there.

The following steps will get you started on trying out the system. If you're considering running this in a production environment, I suggest running your [infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_Code) and using something like [Ansible](https://www.ansible.com/) or [AWS ECS](https://aws.amazon.com/ecs/) depending on your existing infrastructure.

If you're looking to just quickly play with Rocket.Chat, check out [their GitHub page](https://github.com/RocketChat/Rocket.Chat) were you can spin up servers on a variety of providers.

### MongoDB

Rocket.Chat stores data in [MongoDB](https://www.mongodb.com/) so you'll need to start that up first. I suggest [mounting a volume](https://docs.docker.com/engine/tutorials/dockervolumes/) in order to get your data to persist. Otherwise, your data will be wiped out if you ever stop the container (restart the host, perform an upgrade, etc).

```bash
# Make the volume directory (to have data persist)
mkdir -P /var/rocketchat/mongo

# Start the Mongo Database container
docker run \
  --detach \
  --name mongodb \
  --restart always \
  --volume /var/rocketchat/mongo:/data/db \
  mongo:3.2 --smallfiles

# NOTE: Version 3.2 is latest at time of writing
```

### Rocket.Chat

You can now start up the Rocket.Chat container. The container will need to be linked to the MongoDB container since the MondoBD container doesn't expose any ports.

```bash
# Start the Rocket.Chat container
docker run \
  --detach \
  --name rocketchat \
  --restart always \
  --link mongodb:mongo \
  --env MONGO_URL="mongodb://mongo:27017/rocketchat" \
  --env PORT="3000" \
  --publish 80:3000 \
  rocket.chat:0.35

# NOTE: Version 0.35 is latest at time of writing
```

This will expose Rocket.Chat on [`http://localhost/`](http://localhost) on the host. It's important to note that this does not provide any encryption (TLS); you'll need to use something like Nginx for that. Check out the TLS Certificate section below for more information.

## Automatic Backups

In order to backup Rocket.Chat, you'll need to perform a [MongoDB dump](https://docs.mongodb.com/manual/reference/program/mongodump/). I have found that the easiest thing is to just use Docker since I don't have Mongo installed on the host.

```bash
# Establish some variables to make the backup more clear
TIMESTAMP=$(date '+%Y%m%d')
BACKUP_DIR="/var/rocketchat/backup/"
BACKUP_FILE="rocketchat-${TIMESTAMP}.tar.gz"
BACKUP_FILE_FULL="${BACKUP_DIR}/${BACKUP_FILE}"
DUMP_LOCATION="/tmp/rocketchat-backup"

# Ensure Mongo dump location exists
mkdir -p "$DUMP_LOCATION"

# Spin up a temporary Docker container to dump the database
docker run \
  --rm \
  --link mongodb:mongodb \
  --volume $DUMP_LOCATION:/dump \
  mongo \
  bash -c 'mongodump --host $MONGODB_PORT_27017_TCP_ADDR'

# Use the tar utility to zip up the directory and delete the original files
tar czf "$BACKUP_FILE_FULL" "$DUMP_LOCATION"
rm -rf "$DUMP_LOCATION"
```

If you run this script via a `cron` job, you'll have a completely automated backup. It goes without saying, but it's wise to test your restore procedure to validate you're doing backups properly.

Of course, you can add a [dead man's switch](https://en.wikipedia.org/wiki/Dead_man%27s_switch) to alert you of when your script fails to run. I personally use [healthchecks.io](https://healthchecks.io), but there are plenty of good options out there.

I have a few extra lines in my script that upload `$BACKUP_FILE_FULL` to an [AWS S3](https://aws.amazon.com/s3/) bucket for really cheap off-site backups. If you use another solution you can add lines as needed.

## TLS Certificate / Encryption

[TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) is incredibly important to protect the privacy of users; it encrypts traffic from the client to the server. I use the [Let's Encrypt](https://letsencrypt.org/) project to acquire a domain validation TLS certificate for free.

I opted to use nginx's [reverse proxy](https://www.nginx.com/resources/admin-guide/reverse-proxy/) capabilities to serve my web requests for me. This also allows me to have nginx terminate my TLS connections since Rocket.Chat doesn't support TLS natively.

There are plenty of guides on how to acquire TLS certificates and use Nginx, as this isn't Rocket.Chat specific, I'll leave this piece out of this post.

## Integrations

### API

The [Rocket.Chat API](https://rocket.chat/docs/developer-guides/rest-api/) is designed to be compatible with the [Slack API](https://api.slack.com/). This means that most anything that integrates with Slack can work with Rocket.Chat (you just need to be able to set the webhook URL). If the application uses Slack's OAuth Integrations, it may not work.

I personally use the API to [send notifications](https://api.slack.com/incoming-webhooks) of infrastructure events into a special channel.

```bash
# Send message into Rocket.Chat #infrastructure room saying the backup is complete.
curl -X POST --data-urlencode "payload={\"text\":\"The backup is complete.\"" https://rocketchat.example.com/hooks/room_id/rocket.cat/AUTH_TOKEN
```

### Chat Bot

We have a resident chat bot named [David Swinton](http://www.imdb.com/title/tt0212720/). He's able to do some neat calculations in natural lanauge by being connected to [Wolfram Alpha](https://www.wolframalpha.com/). He's powered by [Hubot](https://hubot.github.com/) and we've configured him with multiple integrations. You can find all sorts of integrations on [npmjs.com](https://www.npmjs.com/search?q=hubot), and of course you can [build your own](https://github.com/github/hubot/blob/master/docs/scripting.md) too.

I've made the descision to make our robot friend stateless, so I don't have to worry about restarting or updating him. He makes calls out to other APIs that maintain state.

[![Chat with David Swinton](https://assets.mide.io/blog/2016-08-12/david-swinton-screenshot.png)](https://assets.mide.io/blog/2016-08-12/david-swinton-screenshot.png)

```bash
# Start the Chat Bot container
docker run \
  --detach \
  --name davidswinton \
  --restart always \
  --link rocketchat:rocketchat \
  --env BOT_NAME="@david.swinton" \
  --env EXTERNAL_SCRIPTS="hubot-help,hubot-rules,hubot-thank-you,hubot-what-the-fox,hubot-podbaydoors,hubot-decide,hubot-hello,hubot-darksky,hubot-wolfram,hubot-suggest" \
  --env HUBOT_DARK_SKY_API_KEY="<MY_KEY>" \
  --env HUBOT_WOLFRAM_APPID="<MY_KEY>" \
  --env LISTEN_ON_ALL_PUBLIC="true" \
  --env ROCKETCHAT_AUTH="password" \
  --env ROCKETCHAT_PASSWORD="<MY_KEY>" \
  --env ROCKETCHAT_ROOM="" \
  --env ROCKETCHAT_URL="rocketchat:3000" \
  --env ROCKETCHAT_USER="david.swinton" \
  rocketchat/hubot-rocketchat:v0.1.4

# NOTE: Version v0.1.4 is latest stable at time of writing
# Also, you may need additional or fewer environment variables depending on your EXTERNAL_SCRIPTS.
```

## Competitor Comparison

The closest hosted competitors to Rocket.Chat are Slack and HipChat.

### Pricing / License

I estimate a Rocket.Chat server can be run (Mongo, Rocket.Chat, Backups, and a chat bot) on an [AWS `t2.micro` instance](https://aws.amazon.com/ec2/instance-types/), and cost approximately $10 a month. These calculations are based off estimates, so keep that in mind.

Without much surprise, Slack is the most expensive alternative. Seeing that my Rocket.Chat server currently has almost 15 users, we'd be looking at a bill of $100 per month! HipChat is better, but we'd still be facing $30 per month. The figure below shows the monthly cost of Rocket.Chat and two competitors as a function of users.

[![Graph showing cost per month](https://assets.mide.io/blog/2016-08-12/cost-per-month.png)](https://assets.mide.io/blog/2016-08-12/cost-per-month.png)

I really wanted a good picture of when a $10/month AWS instance would pay for itself. Come to find out, it's much sooner than I expected. At just five people, it is cheaper per month, than the two major competitors. This was not easily seen via the figure above. The figure below, however depicts this very clearly.

[![Graph showing cost per user](https://assets.mide.io/blog/2016-08-12/cost-per-user.png)](https://assets.mide.io/blog/2016-08-12/cost-per-user.png)

There is a hidden cost of maintenance; I haven't spent a lot of time maintaining the system, but I'm also not running a [high availability](https://en.wikipedia.org/wiki/High_availability) environment. Keep this in mind if you're implementing a system with more strict requirements.

### Self-Hosting

One nice feature of hosting the service on your own hardware, is that you have complete control over the data. You can define exactly how you want people to access your system.

You can run your own [HipChat Server](https://www.hipchat.com/server) which grants you the ability to have better control over your data, but you still need to pay steep licensing fees ($1,800 for 25 users for one year).

## My Family's Utilization

To give you an idea of the use, here is a graph showing the number of messages sent since we set up the server. We love using Rocket.Chat and we think you will too!

[![Graph showing our utilization](https://assets.mide.io/blog/2016-08-12/messages-sent-over-time.png)](https://assets.mide.io/blog/2016-08-12/messages-sent-over-time.png)

## Thank You

I'd like to extend my deep gratitude to the [Rocket.Chat development team](https://rocket.chat/team) for working on what I believe to be one of the best open source projects.

While time can be a precious commodity, I try to contribute to the project and hopefully this blog post will give the project a little more publicity. If Rocket.Chat seems like something neat to you, consider running it to share the love with friends.

Great job everyone, keep up the awesome work!
