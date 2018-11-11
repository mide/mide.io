# frozen_string_literal: true

require 'twitter'
require 'sanitize'

module TweetCollection
  # Used by Jekyll
  class Generator < Jekyll::Generator
    # Function which will be called by Jekyll:
    # - Will raise exception if the Twitter handle is not set.
    # - Returns a hash of Tweets (See tweet method for format) which are live
    #   (from Twitter) unless offline mode is active, in which case it will
    #   return a fake hash of tweets.
    def generate(site)
      @site = site.dup.freeze
      raise 'No twitter_handle defined.' if twitter_handle.empty?

      site.data['tweets'] = (offline_mode? ? testing_tweets : tweets)
    end

    private

    def offline_mode?
      @site.config.fetch('twitter_force_offline', false).to_s == 'true'
    end

    def twitter_handle
      @site.config.fetch('twitter_handle', nil).to_s.strip
    end

    def tweet_display_count
      @site.config.fetch('twitter_display_count', 10).to_i
    end

    def twitter_client
      Twitter::REST::Client.new do |config|
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
    #                             direct inclusion in a template.
    #         'date_formatted' => The date of the tweet in the format
    #                             "September 1 @ 1:27 AM UTC"
    #         'date'           => The raw Tweet timestamp (Ruby::Time object)
    #         'url'            => The URL that points to this particular tweet
    #                             on Twitter.
    #         'id'             => The Twitter ID (integer) of the tweet.
    #     }
    # ]
    def tweets
      raw_tweets.map do |t|
        {
          html_text: prepare(t.full_text),
          date_formatted: t.created_at.strftime('%B %e @ %l:%M %p UTC'),
          date: t.created_at,
          url: "https://twitter.com/#{t.user.screen_name}/status/#{t.id}",
          id: t.id
        }
      end
    end

    def raw_tweets
      twitter_client.user_timeline(twitter_handle, count: tweet_display_count)
    rescue Twitter::Error::Forbidden
      puts 'Twitter Gem was unable to authenticate. Did you set the '\
           'TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, '\
           'TWITTER_ACCESS_TOKEN, and TWITTER_ACCESS_TOKEN_SECRET environment '\
           'variables? Are they invalid?'
      raise
    end

    def testing_tweets
      [
        'This is a local Tweet (not actually tweeted).',
        'Loving the weather! #warm',
        'I use @jekyllrb to power my website! #web https://www.example.com',
        'This is a test of <strong><em>HTML</em></strong> stripping.'
      ].map do |t|
        { 'html_text'      => prepare(t),
          'date_formatted' => 'June 1 @ 1:27 AM UTC',
          'url'            => 'https://twitter.com/cranstonide' }
      end
    end

    # Takes raw text (of a Tweet) and returns valid HTML which will insert links
    # for hashtags, mentions and links. In other words "@jekyllrb" becomes
    # "<a href='https://www.twitter.com/jekyllrb'>@jekyllrb</a>". It is expected
    # that the return result from this function is 'safe' to include on a site.
    def prepare(tweet_text)
      t = Sanitize.fragment(tweet_text.dup)
      # Evaluate websites first, because we insert links after and it would
      # cause duplicate nested links.
      t.gsub!(%r{(?<website>https?:\/\/[^\s]+)},
              '<a href="\k<website>">\k<website></a>')
      t.gsub!(/@(?<username>\w+)/,
              '<a href="https://twitter.com/\k<username>">@\k<username></a>')
      t.gsub!(/#(?<hashtag>\w+)/,
              '<a href="https://twitter.com/hashtag/\k<hashtag>">'\
              '#\k<hashtag></a>')
      t
    end
  end
end
