# frozen_string_literal: true

require 'colorator'
require 'exifr/jpeg'
require 'html-proofer'
require 'jekyll'
require 'net/http'
require 'rubocop/rake_task'

# Returns a list of domains, in plain string format. Leave off 'https://www.'
# and '/path/to/file.html', as these will be added in the regex of ignored_urls.
def ignored_domains
  @_ignored_domains ||= %(
    localhost
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

def markdown_files
  md_files = Dir.glob('**/*.md')
  md_files.sort.reject { |dir| dir.start_with? 'vendor/' }
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
    puts "Looking at #{markdown_files.join ', '}"
    markdown_files.each do |directory|
      run_command "mdl -s 'markdown_lint_style.rb' #{directory}"
    end
  end
end

namespace 'remote' do
  task exif: %i[] do
    failed_count = 0
    markdown_files.each do |file|
      puts "Inspecting Markdown file '#{file}'..."
      images = File.read(file).scan(%r{https?:\/\/[^\s\"\)]+\.jpe?g}).uniq
      images.each do |image_url|
        # Download File, Write to Disk
        url = URI.parse(image_url)
        request = Net::HTTP::Get.new(url.request_uri)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == 'https')
        image_content = http.request(request).body
        File.write('/tmp/mide_io_test.jpg', image_content)

        # Examine EXIF Data
        image = EXIFR::JPEG.new('/tmp/mide_io_test.jpg')

        if image.exif?
          failed_count += 1
          puts "[#{'WARN'.yellow}] The image #{image_url} defines the " \
            "following #{image.to_hash.keys.count} EXIF properties: " \
            "#{image.to_hash.keys.sort.join(', ')}"
        else
          puts "[#{'PASS'.green}] The image #{image_url} does not define any " \
            'EXIF data.'
        end
      end
    end
    if failed_count.positive?
      raise "Found #{failed_count} files with EXIF data. Expected zero."
    end
  end

  task links: %i[build] do
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
end

namespace 'test' do
  task html: %i[build] do
    opts = {
      check_html: true,
      check_img_http: true,
      disable_external: true
    }
    run_html_proofer!(opts)
  end
end
