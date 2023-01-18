#!/usr/bin/env ruby
require "ostruct"
require "optparse"
require "yaml"
require "net/http"
require 'shellwords'
#require "gemrake"

DATA_STORE_FILENAME = File.expand_path('~/.web-puc-data.yml')
CACHE_EXPIRATION_PERIOD = 7*24*60*60

class LibraryNotImplementedException < Exception
end

class Optparse
  def self.parse(args)
    options = OpenStruct.new
    options.exclude = []
    options.libs = []
    options.clear = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: web-puc [options] <files>'

      opts.on('-e', '--exclude GLOB', Array, 'Exclude from consideration all files matching GLOB') do |list|
        options.exclude = list
      end

      opts.on('-c', '--clear', 'Clear cached version data') do
        options.clear = true
      end

      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

      opts.on('-l', '--libs GLOB', Array, 'libs to search') do |list|
        options.libs = list
      end

      # TODO: make this work
      #opts.on('-v', '--version', 'Show version') do
      #  puts Gem::Specification::load(File.expand_path('../web-puc.gemspec', __FILE__)).version
      #  exit
      #end

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
  if !libs_cached.nil? && !libs_cached[lib].nil? && Time.at(libs_cached[lib]['expired']) < Time.now
    libs_versions[lib] = libs_cached[lib]
  else
    # Fetch using net/http
    response_text = Net::HTTP.get(URI("https://api.cdnjs.com/libraries/#{lib}?fields=assets"))
#    response = JSON.parse HTTP.get("https://api.cdnjs.com/libraries/#{lib}?fields=assets").body
    response = JSON.parse response_text
    unless response['assets'].nil?
      libs_versions[lib] = Hash.new
      libs_versions[lib]['version'] = Array.new
      libs_versions[lib]['expired'] = Time.now.to_i + CACHE_EXPIRATION_PERIOD
      response['assets'].each_with_index { |asset, index|
        # first version is a most actual
        next if index == 0
        libs_versions[lib]['version'].push asset['version']
      }
    end
  end
}
File.write(DATA_STORE_FILENAME, libs_cached.merge(libs_versions).to_yaml)

puts "web-puc"
# Make this work:
# puts "web-puc #{Gem::Specification::load(File.expand_path('../web-puc.gemspec', __FILE__)).version}"

return_status = 0
files.each { |file|
  file = file.shellescape
  libs_versions.each { |lib, val|
    val['version'].each { |v|

      link = get_link(lib, v)
      matches = %x[ grep -nh -F #{link} #{file} 2>/dev/null].lines
      matches.each { |match|
        description = match[match.index(':') + 1, match.length]
        line = match[0, match.index(':')].to_i
        puts "#{file}:#{line}:#{description}"
        return_status = 1
      }
    }
  }
}

exit return_status