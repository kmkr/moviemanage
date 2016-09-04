#!/usr/bin/ruby

require 'optparse'

require_relative 'moviename/processor'
require_relative 'common/file_finder'
require_relative 'user_interfaces/repl_interface'
require_relative 'user_interfaces/sequential_task_interface'
require_relative 'mover/movie_mover'
require_relative 'foldercleaner/folder_cleaner'
require_relative 'common/settings'
require_relative 'processors/start_movie_processor'
require_relative 'processors/end_movie_processor'
require_relative 'processors/existing_videos'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: mm.rb [options]"

  opts.on("-n", "--name [ARG]", "Set movie name") do |v|
    if v
      options[:movie] = v
    else
      options[:movie] = ""
    end
  end
  opts.on("-m [ARG]", "--move [ARG]", "Move files. Optional filter for where to move.") do |v|
    if v
      options[:move] = v
    else
      options[:move] = ""
    end
  end
  opts.on("-a", "--performers", "Set performers names") do |v|
    options[:performers] = v
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
  opts.on("-f FILEMASK", "--filemask FILEMASK", "Use filemask (regexp) instead of current folder") do |v|
    options[:file] = v
  end
  opts.on("-r ARG", "--remote ARG", "Play file remote. ARG will be interpolated into template in Settings.remote.") do |v|
    options[:remote] = v
  end
  opts.on("--cut", "Cut video (inplace edit)") do |v|
    options[:cut] = v
  end
  opts.on("-r ARG", "--remote ARG", "Play file remote. ARG will be interpolated into template in Settings.remote.") do |v|
    options[:remote] = v
  end
  opts.on("-o CONFIG", "--config CONFIG", "Use custom config file instead of config.yml. Will override ENV['MM_CLIENT_CONFIG']") do |v|
    options[:config] = v
  end
  opts.on("-u", "--repl", "Use REPL-ui") do |v|
    options[:repl] = v
  end
  opts.on("--scan PATTERN", "Scan for existing videos using pattern") do |v|
    options[:scan] = v
  end
end.parse!

config = options[:config]
unless config
  config = ENV['MM_CLIENT_CONFIG']
  config = "config.yml" unless config
end

Settings.load!(config)

files = FileFinder.new.find(!!options[:file])
if options[:file]
  files.delete_if { |file|
    !file.match(Regexp.new(options[:file]))
  }
end 

if options[:movie]
  MovieNameProcessor.new.process(files, options[:movie])
end

if options[:scan]
  ExistingVideos.new.find_and_print options[:scan]
end

if options[:performers] or options[:categories] or options[:tease] or options[:audio_extract] or options[:split] or options[:repl]

  if options[:offset]
    puts "Looking for '#{options[:offset]}'"
    puts files.inspect
    skipto = files.find_index { |file | File.basename(file).match(/\A#{options[:offset]}.*/) } or 0
    puts "Skipping to #{options[:offset]} (index #{skipto}) files"
    files.shift(skipto)
  end

  files.each_with_index do |f, index|
    percentage = (((index+1) / files.length) * 100).to_i
    puts "Processing file number #{index+1} of #{files.length} (#{percentage}%)"
    file = File.basename(f)
    StartMovieProcessor.new(options[:remote]).process file, file
    if options[:repl] 
      ReplInterface.new.run(file, options)
    else
      SequentialTaskInterface.new(options).run(file, options)
    end
    EndMovieProcessor.new(options[:remote]).process file, file
  end
end

if options[:move]
  # todo: support for moving only "files"
  MovieMover.new.auto_move(options[:move])
  FolderCleaner.new.consider_clean
end
