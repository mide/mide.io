require 'jekyll'
require 'html-proofer'

# Returns a list of domains, in plain string format. Leave off 'https://www.'
# and '/path/to/file.html', as these will be added in the regex of ignored_urls.
def ignored_domains
  @_ignored_domains ||= %{
    localhost
    maxcdn.com
  }.lines.map(&:strip).reject(&:empty?).sort.freeze
end

# Returns an array of domains formatted in a very forgiving regex.
def ignored_urls
  ignored_domains.map { |domain| /https?:\/\/.*#{domain.gsub('.', '\.')}(\/.*)?/ }
end

def external_test_enabled?
  ENV['TEST_DISABLE_EXTERNAL'].to_s.downcase != "true"
end

task :build => ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

task :test => [:build] do
  Jekyll.logger.info "Testing the generated site."
  Jekyll.logger.info "Ignoring the following #{ignored_domains.count} domain(s) from link rot checks: #{ignored_domains.join(', ')}."
  # Use html-proofer https://github.com/gjtorikian/html-proofer
  opts = {
    cache: {timeframe: '1w'},
    check_html: true,
    check_img_http: true,
    disable_external: external_test_enabled?,
    http_status_ignore: [999],
    hydra: { max_concurrency: 10 },
    internal_domains: ['www.mide.io'],
    log_level: :debug,
    url_ignore: ignored_urls
  }
  HTMLProofer.check_directory('./_site', opts).run
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
