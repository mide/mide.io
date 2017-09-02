require 'twitter'

module TweetCollection
  class Generator < Jekyll::Generator

    DEFAULT_TWITTER_DISPLAY_COUNT = 10

    # Function which will be called by Jekyll:
    # - Will raise exception if the Twitter handle is not set.
    # - Returns a hash of Tweets (See tweet method for format) which are live
    #   (from Twitter) unless offline mode is active, in which case it will
    #   return a fake hash of tweets.
    def generate(site)
      @site = site.dup.freeze
      ensure_twitter_handle!
      site.data['tweets'] = (offline_mode? ? testing_tweets : tweets)
    end

    private

    # Returns true if config key "twitter_force_offline" set to "true",
    # otherwise will return false.
    def offline_mode?
      @site.config.fetch("twitter_force_offline", false).to_s == 'true'
    end

    # Will raise an exception if there is no "twitter_handle" defined in the
    # Jekyll config file.
    def ensure_twitter_handle!
      raise "No twitter_handle defined in configuration." if twitter_handle.length == 0
    end

    # Fetches the Twitter handle from the configuration file. Return will always
    # be a string. If the returned value is an empty string, there was nothing
    # defined.
    def twitter_handle
      @site.config.fetch("twitter_handle", nil).to_s.strip
    end

    # Fetches the display count (how many tweets to return) as an integer. If no
    # value is specified, will return DEFAULT_TWITTER_DISPLAY_COUNT.
    def tweet_display_count
      @site.config.fetch("twitter_display_count", DEFAULT_TWITTER_DISPLAY_COUNT).to_i
    end

    # Given a Tweet object, get the URL that reprsents the specific tweet on
    # Twitter. Uses the form "twitter.com/user/status/id".
    def tweet_url(tweet)
      "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
    end

    # Creates and memoizes a Twitter Gem Client with the appropriate
    # configurations. The configurations are set via environment variables.
    def client
      @_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    # Returns an array of hashes of Tweets in the following format:
    # [
    #     {
    #         'html_text'      => String of HTML formatted text, ready for
    #                              direct inclusion in a template.
    #         'date_formatted' => The date of the tweet in the format
    #                             "September 1 @ 1:27 AM UTC"
    #         'date'           => The raw Tweet timestamp (Ruby::Time object)
    #         'url'            => The URL that points to this particular tweet
    #                             on Twitter.
    #         'id'             => The Twitter ID (integer) of the tweet.
    #     }
    # ]
    def tweets
      raw_tweets = client.user_timeline(twitter_handle, {count: tweet_display_count})
      raw_tweets.map do |t|
        {
          'html_text'      => hyperlink(t.full_text),
          'date_formatted' => t.created_at.strftime("%B %e @ %l:%M %p UTC"),
          'date'           => t.created_at,
          'url'            => tweet_url(t),
          'id'             => t.id
        }
      end
    rescue Twitter::Error::Forbidden
      puts "Twitter Gem was unable to authenticate. Did you set the TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, TWITTER_ACCESS_TOKEN, and TWITTER_ACCESS_TOKEN_SECRET environment variables? Are they invalid?"
      raise
    end

    def testing_tweets
      # dupe for display count
      [
        "This is a local Tweet (not actually tweeted).",
        "Loving the weather! #warm",
        "I use @jekyllrb to power my website! #opensource https://www.example.com"
      ].map do |t|
        {
          'html_text'      => hyperlink(t),
          'date_formatted' => "June 1 @ 1:27 AM UTC",
          'date'           => nil,
          'url'            => "https://twitter.com/cranstonide",
          'id'             => nil
        }
      end
    end

    # Takes raw text (of a Tweet) and returns valid HTML which will insert links
    # for hashtags, mentions and links. In other words "@jekyllrb" becomes
    # "<a href='https://www.twitter.com/jekyllrb'>@jekyllrb</a>". It is expected
    # that the return result from this function is 'safe' to include on a site.
    # TODO sanitize!
    def hyperlink(tweet_text)
      t = tweet_text.dup
      # Evaluate websites first, because we insert links after.
      t.gsub!(/(?<website>https?:\/\/[^\s]+)/, '<a href="\k<website>">\k<website></a>')
      t.gsub!(/@(?<username>\w+)/, '<a href="https://twitter.com/\k<username>">@\k<username></a>')
      t.gsub!(/#(?<hashtag>\w+)/, '<a href="https://twitter.com/hashtag/\k<hashtag>">#\k<hashtag></a>')
      t
    end

  end
end
