#!/usr/bin/env ruby
require 'rake'
require 'stat'
require 'shellwords'
require 'http'
require 'yaml'
require_relative 'version'

DATA_STORE_FILENAME = File.expand_path('~/.libs_versions.yml')
CACHE_EXPIRATION_PERIOD = 7*24*60*60

class LibraryNotImplementedException < Exception
end

class Optparse

  def self.parse(args)
    options = OpenStruct.new
    options.exclude = []
    options.libs = []
    options.clear = false
    options.stat = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: web-puc [options] <files>'

      opts.on('-e', '--exclude GLOB', Array, 'Exclude from consideration all files matching GLOB') do |list|
        options.exclude = list
      end

      opts.on('-c', '--clear', 'Clear cached version data') do
        options.clear = true
      end

      opts.on('--stat', 'Output in STAT format') do
        options.stat = true
      end

      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

      opts.on('-l', '--libs GLOB', Array, 'libs to search') do |list|
        options.libs = list
      end

      opts.on_tail('-v', '--version', 'Show version') do
        puts "web-puc #{WebPuc::VERSION}"
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end

end

def get_link(lib, version)
  case lib
    when 'twitter-bootstrap'
      "//netdna.bootstrapcdn.com/bootstrap/#{version}/"
    when 'font-awesome'
      "//netdna.bootstrapcdn.com/font-awesome/#{version}/"
    else
      raise LibraryNotImplementedException
  end
end

ARGV << '-h' if ARGV.empty?

options = Optparse.parse(ARGV)

if options.clear
  File.delete(DATA_STORE_FILENAME) if File.exists? DATA_STORE_FILENAME
  puts 'Cleared'
  exit
end

files = ARGV

if options.exclude.length > 0
  exclude_files = `find #{options.exclude.join(' ')} -type f`.split
  exclude_block = "-and ! \\( -path #{exclude_files.join(' -or -path ')} -or -false \\)"
else
  exclude_block = ''
end

cmd = "find #{files.join(' ')} -type f #{exclude_block}"
files = %x[ #{cmd}].split("\n")
abort 'command failed' unless $?.success?

libs_versions = Hash.new
if File.exists? DATA_STORE_FILENAME
  libs_cached = YAML.load_file(DATA_STORE_FILENAME)
else
  libs_cached = Hash.new
end

options.libs.each { |lib|
  if !libs_cached.nil? && !libs_cached[lib].nil? && libs_cached[lib]['expired'] < Time.now
    libs_versions[lib] = libs_cached[lib]
  else
    response = JSON.parse HTTP.get("https://api.cdnjs.com/libraries/#{lib}?fields=assets").body
    unless response['assets'].nil?
      libs_versions[lib] = Hash.new
      libs_versions[lib]['version'] = Array.new
      libs_versions[lib]['expired'] = Time.now + CACHE_EXPIRATION_PERIOD
      response['assets'].each_with_index { |asset, index|
        # first version is a most actual
        next if index == 0
        libs_versions[lib]['version'].push asset['version']
      }
    end
  end
}
File.write(DATA_STORE_FILENAME, libs_cached.merge(libs_versions).to_yaml)

process = StatModule::Process.new('WebPuc')
process.version = "#{WebPuc::VERSION}"
process.description = 'Validate your web project uses the latest CSS & JS includes.'
process.maintainer = 'William Entriken'
process.email = 'github.com@phor.net'
process.website = 'https://github.com/fulldecent/web-puc'
process.repeatability = 'Volatile'
stat = StatModule::Stat.new(process)

stat.print_header if options.stat
files.each { |file|
  file = file.shellescape
  libs_versions.each { |lib, val|
    val['version'].each { |v|

      link = get_link(lib, v)
      matches = %x[ grep -nh -F #{link} #{file} 2>/dev/null].lines
      matches.each { |match|
        description = match[match.index(':') + 1, match.length]
        line = match[0, match.index(':')].to_i
        location = StatModule::Location.new(file)
        location.begin_line = line
        location.end_line = line

        finding = StatModule::Finding.new(true, description, 'Old version')
        finding.location = location

        stat.findings.push(finding)

        stat.print_finding if options.stat
      }
    }
  }
}

if options.stat
  stat.print_footer
else
  if stat.findings.length > 0
    stat.findings.each { |finding|
      puts finding.print true
    }
    abort stat.summary_print true
  end
  puts stat.summary_print true
end