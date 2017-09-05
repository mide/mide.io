require 'jekyll'
require 'html-proofer'

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
    url_ignore: [
      /https?:\/\/.*soundcloud\.com\/?.*/,
      /https?:\/\/.*maxcdn\.com\/?.*/,
      /https?:\/\/localhost\/?.*/
    ],
    http_status_ignore: [999]}
  HTMLProofer.check_directory('./_site', opts).run
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
