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

def test_local!
  Jekyll.logger.info "Testing the Local Assets."
  opts = {
    check_html: true,
    check_img_http: true,
    disable_external: true
  }
  HTMLProofer.check_directory('./_site', opts).run
end

def test_remote!
  Jekyll.logger.info "Testing the Remote Assets."
  Jekyll.logger.info "Ignoring the following #{ignored_domains.count} domain(s) from link rot checks: #{ignored_domains.join(', ')}."
  opts = {
    cache: {timeframe: '1w'},
    external_only: true,
    http_status_ignore: [999],
    hydra: { max_concurrency: 10 },
    internal_domains: ['www.mide.io'],
    url_ignore: ignored_urls
  }
  HTMLProofer.check_directory('./_site', opts).run
end

task :build => ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

task :test => [:build] do
  known_test_suites = ['ALL', 'REMOTE', 'LOCAL']
  test_suite = ENV.fetch("TEST_SUITE", 'ALL').upcase

  if known_test_suites.include? test_suite
    test_local!  if ['ALL', 'LOCAL'].include? test_suite
    test_remote! if ['ALL', 'REMOTE'].include? test_suite
  else
    raise "Unknown TEST_SUITE #{test_suite}. Expecting one of: #{known_test_suites.join(', ')}."
  end
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
