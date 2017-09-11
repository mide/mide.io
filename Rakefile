require 'jekyll'
require 'html-proofer'
require 'rubocop/rake_task'

# Returns a list of domains, in plain string format. Leave off 'https://www.'
# and '/path/to/file.html', as these will be added in the regex of ignored_urls.
def ignored_domains
  @_ignored_domains ||= %{
    localhost
    maxcdn.com
    un.org
  }.lines.map(&:strip).reject(&:empty?).sort.freeze
end

# Returns an array of domains formatted in a very forgiving regex.
def ignored_urls
  ignored_domains.map { |domain| /https?:\/\/.*#{domain.gsub('.', '\.')}(\/.*)?/ }
end

task :build => ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

RuboCop::RakeTask.new(:rubocop)

task :style => [:rubocop]

task :test => [:build, :style] do
  Jekyll.logger.info "Ignoring the following #{ignored_domains.count} domain(s) from link rot checks: #{ignored_domains.join(', ')}."
  opts = {
    cache: {timeframe: '1w'},
    check_html: true,
    check_img_http: true,
    http_status_ignore: [999],
    hydra: { max_concurrency: 10 },
    internal_domains: ['www.mide.io'],
    url_ignore: ignored_urls
  }
  HTMLProofer.check_directory('./_site', opts).run
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
