require 'jekyll'
require 'html-proofer'

task :build => ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

task :serve do
  Jekyll::Commands::Serve.process({})
end

task :test => [:build] do
  # Use html-proofer https://github.com/gjtorikian/html-proofer
  opts = {
    check_html: true,
    check_img_http: true,
    internal_domains: ['www.mide.io'],
    url_ignore: [
      /https?:\/\/(www.)?adafruit.com\/?.*/
      /https?:\/\/localhost\/?.*/
    ],
    http_status_ignore: [999]}
  HTMLProofer.check_directory('./_site', opts).run
end

file '_site/index.html' do
  Jekyll::Commands::Build.process({profile: true})
end
