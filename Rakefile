require 'jekyll'
require 'html-proofer'

task :build do
  Jekyll::Commands::Build.process({profile: true})
end

task :clean do
  Jekyll::Commands::Clean.process({})
end

task :serve do
  Jekyll::Commands::Serve.process({})
end

task :test => [:build] do
  # Use html-proofer https://github.com/gjtorikian/html-proofer
  opts = {
    disable_external: true,
    check_html: true,
    check_img_http: true,
    url_ignore: [/https?:\/\/localhost\/?.*/],
    http_status_ignore: [999]}
  HTMLProofer.check_directory('./_site', opts).run
end
