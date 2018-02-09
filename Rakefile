# frozen_string_literal: true

require 'jekyll'
require 'html-proofer'
require 'rubocop/rake_task'

# Returns a list of domains, in plain string format. Leave off 'https://www.'
# and '/path/to/file.html', as these will be added in the regex of ignored_urls.
def ignored_domains
  @_ignored_domains ||= %(
    localhost
    donottrack-doc.com
  ).lines.map(&:strip).reject(&:empty?).sort.freeze
end

# Returns an array of domains formatted in a very forgiving regex.
def ignored_urls
  ignored_domains.map do |domain|
    %r{https?:\/\/.*#{domain.gsub('.', '\.')}(\/.*)?}
  end
end

def run_html_proofer!(opts)
  Jekyll.logger.info 'HTMLProofer: Ignoring the following ' \
    "#{ignored_domains.count} domain(s) from link rot checks: " \
    "#{ignored_domains.join(', ')}."

  HTMLProofer.check_directory('./_site', opts).run
end

def run_command(cmd)
  puts "Running '#{cmd}'"
  sh cmd
end

task build: ['_site/index.html']

task :clean do
  Jekyll::Commands::Clean.process({})
end

file '_site/index.html' do
  Jekyll::Commands::Build.process(profile: true)
end

namespace 'lint' do
  task everything: %i[ruby yaml]

  RuboCop::RakeTask.new(:ruby).tap do |task|
    task.options = %w[--fail-fast --extra-details]
  end

  task yaml: %i[] do
    files = Dir.glob('*.y*ml', File::FNM_DOTMATCH)
    run_command "yaml-lint #{files.join(' ')}" unless files.empty?
  end

  task markdown: %i[] do
    inspect_directories = Dir.glob('**/*.md')
    inspect_directories.reject! { |dir| dir.start_with? 'vendor/' }
    puts "Looking at #{inspect_directories.join ', '}"
    inspect_directories.each do |directory|
      run_command "mdl -s 'markdown_lint_style.rb' #{directory}"
    end
  end
end

namespace 'test' do
  task remote: %i[build] do
    opts = {
      cache: { timeframe: '1w' },
      external_only: true,
      http_status_ignore: [999],
      hydra: { max_concurrency: 10 },
      internal_domains: ['www.mide.io'],
      url_ignore: ignored_urls
    }
    run_html_proofer!(opts)
  end

  task local: %i[build] do
    opts = {
      check_html: true,
      check_img_http: true,
      disable_external: true
    }
    run_html_proofer!(opts)
  end
end
