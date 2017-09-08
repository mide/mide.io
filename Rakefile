require 'jekyll'
require 'html-proofer'

# Returns a list of domains, in plain string format. Leave off 'https://www.'
# and '/path/to/file.html', as these will be added in the regex of ignored_urls.
def ignored_domains
  [
    "soundcloud.com",
    "maxcdn.com",
    "localhost"
  ]
end

# Returns an array of domains formatted in a very forgiving regex.
def ignored_urls
  ignored_domains.map { |domain| /https?:\/\/.*#{domain.replace('.', '\.')}(\/.*)?/ }
end

task :build => ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

task :test => [:build] do
  # Use html-proofer https://github.com/gjtorikian/html-proofer
  opts = {
    log_level: :debug,
    cache: {timeframe: '1w'},
    check_html: true,
    check_img_http: true,
    internal_domains: ['www.mide.io'],
    hydra: { max_concurrency: 10 },
    url_ignore: ignored_urls,
    http_status_ignore: [999]}
  HTMLProofer.check_directory('./_site', opts).run
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
