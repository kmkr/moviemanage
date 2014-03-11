#!/usr/bin/ruby

require 'optparse'

require_relative 'moviename/processor'
require_relative 'common/file_finder'
require_relative 'rename_runner'
require_relative 'mover/movie_mover'
require_relative 'foldercleaner/folder_cleaner'
require_relative 'settings'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: mm.rb [options]"

  opts.on("-n", "--name", "Set movie name") do |v|
    options[:movie] = v
  end
  opts.on("-m", "--move", "Move files at the end") do |v|
    options[:move] = v
  end
  opts.on("-a", "--actresses", "Set actresses names") do |v|
    options[:actresses] = v
  end
  opts.on("-c", "--categories", "Add categories") do |v|
    options[:categories] = v
  end
  opts.on("-t", "--tease", "Create tease clips") do |v|
    options[:tease] = v
  end
  opts.on("-e", "--audio-extract", "Extract audio") do |v|
    options[:audio_extract] = v
  end
  opts.on("--offset FILENAME", "Offset file/start at file match") do |v|
    options[:offset] = v
  end
  opts.on("-s", "--split", "Split large video") do |v|
    options[:split] = v
  end
  opts.on("-f FILENAME", "--filename FILENAME", "Use file instead of current folder") do |v|
    options[:file] = v
  end
  opts.on("-r", "--remote", "Play file remote (need 'remote: http://ip:port' in config.yml)") do |v|
    options[:remote] = v
  end

  opts.on("--all", "Do everything (not including audio_extract nor split)") do |v|
    options[:movie] = true
    options[:categories] = true
    options[:actresses] = true
    options[:move] = true
    options[:tease] = true
  end
end.parse!

Settings.load!("config.yml")

puts options[:file]
if options[:movie]
  MovieNameProcessor.new.process (options[:file] or FileFinder.new.find)
end

if options[:actresses] or options[:categories] or options[:tease] or options[:audio_extract] or options[:split]
  
  files = if options[:file] then [ options[:file] ] else FileFinder.new.find end
  if options[:offset]
    puts "Looking for '#{options[:offset]}'"
    puts files.inspect
    skipto = files.find_index { |file | file.match(/.*#{options[:offset]}.*/) } or 0
    puts "Skipping to #{options[:offset]} (index #{skipto}) files"
    files.shift(skipto)
  end

  files.each do |f|
    RenameRunner.new(options).run(File.basename(f), options)
  end
end

if options[:move]
  MovieMover.new.move  
  FolderCleaner.new.consider_clean
end
