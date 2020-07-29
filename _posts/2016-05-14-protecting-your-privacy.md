---
layout: post
title:  "Protecting Your Privacy"
date:   2016-05-14 11:30:00
---

## Why Privacy is Important

Privacy is a very hot topic right now with advertisers trying to deliver relevant ads and the potential for businesses or governments trying to peek into your personal doings for more information.

While I could go down a [deep rabbit hole](https://en.wikipedia.org/wiki/Alice%27s_Adventures_in_Wonderland) of government spying concerns, I'm going to keep this focused on businesses and advertisers whose business model depends on your information. For more information on what I mean, check out the Interactive [Do Not Track Documentary](https://donottrack-doc.com/), an awesome project showing how your data makes people money.

If you feel that you have nothing to hide and this doesn't impact you, please [email me]({{site.url}}/contact) with your bank accounts and complete internet browser history. It's never been about having something that needs to be hidden, it's the fact that it's none of my business which websites you browsed on Friday evening or how you spent your last paycheck.

## Steps I've Taken

I've taken a few steps to make privacy easier for my visitors. Keep in mind that while I'm privacy conscious, many websites aren't.

### Google Analytics Deletion

[I recently decided to disable]({{site.source_url}}/commit/e177909cf820c3af79ef855a48fcf48fb7b49324) Google Analytics. While it provided me with some great insight into the visitors of my website; I made the conscious decision that my visitor's privacy was not worth my curiosity factor.

I have not replaced the functionality of [Google Analytics](https://www.google.com/analytics/) with another tool (like [Matomo (previously Piwik)](https://matomo.org/) or others), but it's worth mentioning that [AWS CloudFront](https://aws.amazon.com/cloudfront/) is collecting some of this information (see the Tin Foil Hat section below).

### HTTPS Addition and Automatic Redirection

I have moved my website hosting away from [GitHub Pages](https://pages.github.com/) because of its lack of [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) support. With the advent of free and automated certificate authorities like [Let's Encrypt](https://letsencrypt.org/) and [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/), there is no reason not to add TLS onto websites and support end-to-end encryption for all browsing.

I now use [AWS S3](https://aws.amazon.com/s3/) to host my website and the [AWS CloudFront](https://aws.amazon.com/cloudfront/) CDN to serve it. The TLS certificate is generated and managed by the [AWS Certificate Manager](https://aws.amazon.com/certificate-manager/).

### Assets Moved to Personal Domain

In an effort to keep my codebase small, I've been reluctant to add assets (photos, videos, etc) to it. This required me to host assets elsewhere, preferably for free or cheap. I previously used the following websites for asset hosting:

- [Google Fonts](https://www.google.com/fonts) for fonts
- [Imgur](https://imgur.com) for images
- [MaxCDN](https://www.maxcdn.com/) for the [FontAwesome](https://fortawesome.github.io/Font-Awesome/) iconic font
- [SoundCloud](https://soundcloud.com) for audio files
- [YouTube](https://www.youtube.com/) for video files

Each location I hosted a file was another external request that a visitor would be required to make, and thus another opportunity for tracking to occur. It's possible that one of the hosts correlates visitors across multiple source domains by inspecting the requests.

All my assets have been moved to `assets.mide.io`, another domain under my control. My visitors no longer need to send requests to third party domains to view my content. This has the added bonus of reducing my dependencies on external sources.

### Embedded Content Removed

I previously embedded YouTube videos and SoundCloud sound clips into my blog entries to make things easier and more active for my viewers. However, I realized just how many assets each of these additions were pulling in.

If the embedded content didn't set any cookies or run any scripts, it still performed a request to fetch the content from a different source. I want my visitors to know explicitly when they're viewing content from a site other than my own, and I have achieved that by requiring a click of a link.

## Tin Foil Hat Considerations

### HTTP to HTTPS Redirection

I do not control the servers that perform HTTP to HTTPS redirection. It is possible that the HTTP server performs tracking based on requests. It is also true that third parties (like employers or internet providers) are able to see the initial HTTP request to `http://www.mide.io` and could perform tracking based on that.

Some websites employ [HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security), a mechanism that causes servers to instruct clients to only communicate over secure channels for some length of time. This policy will cause the browser to perform HTTP to HTTPS redirections before requesting any content from the server, making [man-in-the-middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) much more difficult. **I do not currently have this enabled for this domain.**

If this is a concern of yours, always make sure you type in `https://` for the website you're visiting or use a browser addon like [HTTPS Everywhere](https://www.eff.org/https-everywhere).

### Lack of Control over TLS Certificate and Key

I do not have control over the TLS private key, it's stored within Amazon's services. Amazon is the entity performing the decryption and the serving of content, they could be logging and gathering metrics on requests. In fact, CloudFront does collect some information from visitors, as can be seen from their [Viewers Report](https://aws.amazon.com/cloudfront/reporting/).

In an ideal situation, I'd be the only one with access to the [private key](https://en.wikipedia.org/wiki/Public-key_cryptography) and the server would be physically and digitally under my control. But this isn't cost effective for me, so this is a compromise that I have to make for now.

### DNS Lookup Privacy Leaks

When you type `www.google.com` into your web browser, it will perform a [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) lookup to translate `google.com` to `216.58.217.142` (for example). This lookup occurs in plaintext and is answered by your DNS server.

Whoever your DNS provider is ([Google](https://developers.google.com/speed/public-dns/), [OpenDNS](https://www.opendns.com/), your provider, or others), they are able to see the DNS lookup for the website you're visiting. The DNS query doesn't reveal any content, but it does reveal that you're visiting that website. For example, if you visit my website, `mide.io`, your provider will know that you're visiting `mide.io` because you performed a DNS query for the domain in cleartext.

Domain Name System Security Extensions ([DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions)) solve some authenticity issues, but does not provide any confidentiality in queries.

## Steps You Can Take

### Browser Options

- [Disable Third Party Cookies](https://duckduckgo.com/?q=how+to+disable+third+party+cookies) - Third party cookies are pieces of information that are set by a website other than the one you're on. For example, if you visit a website and it includes embedded YouTube videos, YouTube _could_ set cookies even though you're not on YouTube. By disabling third party cookies, you allow cookies to be set _only_ by the website you're visiting.
- [Enable Do Not Track (DNT)](https://duckduckgo.com/?q=how+to+enable+do+not+track) - The browser option "Do Not Track" will set a new request header, `DNT=1`. This tells websites you visit that you would not like to be tracked. Because of the nature of the internet, only the good websites will respect this flag so while it's great to turn on, the DNT option should not be your only line of defense.
- [Enable Click-To-Play Plugins](https://duckduckgo.com/?q=how+to+enable+click+to+play+plugins) - Some browser plugins, like Adobe Flash, can run code in your browser. In some cases, this code is less limited than the rest of the internet since it has the ability to run native code on your computer. By requiring "click to play", you opt into each plugin, rather than having them present without your knowledge.
- You may also want to check your browser related settings. Sometimes there are "features" that could compromise your privacy. ([Mozilla Firefox](https://support.mozilla.org/en-US/kb/settings-privacy-browsing-history-do-not-track), [Google Chrome](https://support.google.com/chrome/answer/114836?hl=en))

### Tools

- [HTTPS Everywhere](https://www.eff.org/https-everywhere) - A browser extension that tries to use HTTPS by default on many websites.
- [Privacy Badger](https://www.eff.org/privacybadger) - A browser extension that blocks known trackers.
- [Duck Duck Go](https://www.duckduckgo.com) - A search engine that promises not to track you
- [Panopticlick](https://panopticlick.eff.org/) - An online test to see how unique your browser fingerprint is.
- [Tor Browser](https://www.torproject.org/) - The Tor Project and its web browser has received a lot of negative light over the last years, but it does a good job at the problem it solves. It bounces your web traffic around the world to provide anonymity on the internet. Be sure to verify that using Tor does not break your local laws before use.

### Review Local Laws

Some jurisdictions prohibit the use of [strong encryption](https://en.wikipedia.org/wiki/Strong_cryptography) or [anonymizing software](https://en.wikipedia.org/wiki/Anonymity). Consult your laws before taking any actions. I am not responsible if you get in trouble for advice you read on the internet.

## Resources

- [The Electronic Frontier Foundation](https://www.eff.org/)
- [Surveillance Self-Defense Guide](https://ssd.eff.org/) from the EFF
- [The Free Software Foundation](https://www.fsf.org/)
- [The curly fry conundrum: Why social media "likes" say more than you might think](https://www.ted.com/talks/jennifer_golbeck_the_curly_fry_conundrum_why_social_media_likes_say_more_than_you_might_think?language=en) by Jennifer Golbeck
- [United Nations: The Universal Declaration of Human Rights](https://www.un.org/en/universal-declaration-human-rights/) (See Article 12)

## Conclusions

Privacy isn't a switch you can turn on, it's a whole lifestyle of decisions. But don't fret, for there are helpful actions you can take at every level. Just remember, once something is public, it's public for good.
