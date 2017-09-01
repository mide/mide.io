require 'twitter'

module TweetCollection
  class Generator < Jekyll::Generator

    def generate(site)
      if !site.config.has_key? 'twitter_handle'
        puts "Included Twitter plugin, but no 'twitter_handle' key found in config."
        site.data['tweets'] = []
        return
      end

      begin
        site.data['tweets'] = tweets(site.config['twitter_handle'])
      rescue Twitter::Error::Forbidden
        puts "Twitter Gem was unable to authenticate. Did you set the TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, TWITTER_ACCESS_TOKEN, and TWITTER_ACCESS_TOKEN_SECRET environment variables?"
        raise
      end
    end

    private

    def client
      @_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end

    def tweets(twitter_handle)
      raw_tweets = client.user_timeline(twitter_handle, {count: 10})
      raw_tweets.map do |t|
        {
          'html_text'      => hyperlink(t.full_text),
          'date_formatted' => t.created_at.strftime("%B %e @ %l:%M %p UTC"),
          'date'           => t.created_at,
          'url'            => tweet_url(t),
          'id'             => t.id
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

    def tweet_url(tweet)
      "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
    end

  end
end
