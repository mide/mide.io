require 'twitter'

module TweetCollection
  class Generator < Jekyll::Generator

    DEFAULT_TWITTER_DISPLAY_COUNT = 10

    def generate(site)
      @site = site.dup.freeze
      ensure_twitter_handle!
      site.data['tweets'] = (offline_mode? ? testing_tweets : tweets)
    end

    private

    def offline_mode?
      @site.config.fetch("twitter_force_offline", false).to_s == 'true'
    end

    def ensure_twitter_handle!
      raise "No twitter_handle defined in configuration." if twitter_handle.length == 0
    end

    def twitter_handle
      @site.config.fetch("twitter_handle", nil).to_s.strip
    end

    def tweet_display_count
      @site.config.fetch("twitter_display_count", DEFAULT_TWITTER_DISPLAY_COUNT).to_i
    end

    def tweet_url(tweet)
      "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
    end

    def client
      @_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

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

    def hyperlink(tweet)
      t = tweet.dup
      # Evaluate websites first, because we insert links after.
      t.gsub!(/(?<website>https?:\/\/[^\s]+)/, '<a href="\k<website>">\k<website></a>')
      t.gsub!(/@(?<username>\w+)/, '<a href="https://twitter.com/\k<username>">@\k<username></a>')
      t.gsub!(/#(?<hashtag>\w+)/, '<a href="https://twitter.com/hashtag/\k<hashtag>">#\k<hashtag></a>')
      t
    end

  end
end
