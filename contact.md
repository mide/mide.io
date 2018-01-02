---
layout: page
title: Contact
permalink: /contact/
---

## Email

Email is the best method of contact and if you wish to do so securely, you may use [my PGP public key](https://keybase.io/mide). Before trusting any key, be sure to verify its authenticity with the owner to prevent man in the middle attacks. You can reach me at `{{ site.email }}`.

## Social Networks

While I'm not huge into social networks, there are a few that I maintain a presence on.

- [mide](https://bitbucket.org/mide/) on Bitbucket
- [mide](https://hub.docker.com/u/mide/) on Docker Hub
- [mide](https://github.com/mide) on GitHub
- [mide](https://gitlab.com/u/mide) on GitLab
- [mide](https://keybase.io/mide) on Keybase
- [Mark Ide](https://linkedin.com/in/markide) on LinkedIn
- [@cranstonide](https://twitter.com/cranstonide) on Twitter

### Twitter Feed

Recent Tweets by [@cranstonide](https://twitter.com/cranstonide):

<div class="tweets">
{% for tweet in site.data.tweets %}
  <div class="tweet">
    <div class="text" data-proofer-ignore>{{ tweet['html_text'] }}</div>
    <div class="date"><a href="{{tweet['url']}}">{{tweet['date_formatted']}}</a></div>
  </div>
{% endfor %}
</div>
