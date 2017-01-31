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
  opts = {disable_external: true}
  HTMLProofer.check_directory('./_site', opts).run
end
