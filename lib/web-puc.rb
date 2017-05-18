#!/usr/bin/env ruby
require 'rake'
require 'stat'
require 'shellwords'
require_relative 'version'

class Optparse

  def self.parse(args)
    options = OpenStruct.new
    options.exclude = []
    options.update = false
    options.stat = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: web-puc [options] <files>'

      opts.on('-e', '--exclude GLOB', Array, 'Exclude from consideration all files matching GLOB') do |list|
        options.exclude = list
      end

      opts.on('-s', '--allow-supported', 'Allow supported versions even if not latest') do
      end

      opts.on('-u', '--update', 'Update web package database') do
        options.update = true
      end

      opts.on('--stat', 'Output in STAT format') do
        options.stat = true
      end

      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
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

ARGV << '-h' if ARGV.empty?

options = Optparse.parse(ARGV)

if options.update
  FileUtils.rm_r Dir[File.expand_path File.dirname(__FILE__) + '/packages/*']

  Dir[File.expand_path File.dirname(__FILE__) + '/package-spiders/*.sh'].each { |file|
    puts "UPDATING #{file}"
    puts %x[ bash #{file} ]
    $stdout.flush
  }
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
good_files = Dir[File.expand_path File.dirname(__FILE__) + '/packages/*.good']
bad_files = good_files.map { |good_file| good_file[0, good_file.length - 'good'.length] + 'bad' }

process = StatModule::Process.new('WebPuc')
process.version = "#{WebPuc::VERSION}"
process.description = 'Validate your web project uses the latest CSS & JS includes.'
process.maintainer = 'William Entriken'
process.email = 'github.com@phor.net'
process.website = 'https://github.com/fulldecent/web-puc'
process.repeatability = 'Volatile'
stat = StatModule::Stat.new(process)

files.each { |file|
  bad_files.each { |bad_file|
    file = file.shellescape
    bad_file = bad_file.shellescape

    matches = %x[ grep -o -nh -F -f #{bad_file} #{file} 2>/dev/null].lines
    matches.each { |match|
      description = match[match.index(':') + 1, match.length]
      line = match[0, match.index(':')].to_i
      location = StatModule::Location.new(file)
      location.begin_line = line
      location.end_line = line

      finding = StatModule::Finding.new(true, description, 'Old version')
      finding.location = location

      stat.findings.push(finding)
    }
  }
}

if options.stat
  puts stat.to_json
else
  if stat.findings.length > 0
    stat.findings.each { |finding|
      puts finding.print true
    }
  end
  puts stat.summary_print(true)
end