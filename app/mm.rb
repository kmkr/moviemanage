#!/usr/bin/ruby
# encoding: utf-8
require 'optparse'

require_relative 'moviename/processor'
require_relative 'rename_runner'

require_relative 'foldercleaner/folder_cleaner'
require_relative 'mover/movie_mover'
require_relative 'movieplayer/movie_player'
require_relative 'common/file_finder'

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
  opts.on("t", "--tease", "Create tease clips") do |v|
    options[:tease] = v
  end
  opts.on("--all", "Do everything") do |v|
    options[:movie] = true
    options[:categories] = true
    options[:actresses] = true
    options[:move] = true
    options[:tease] = true
  end
end.parse!

Settings.load!("config.yml")


if options[:movie]
  MovieNameProcessor.new.process FileFinder.new.find
end

if options[:actresses] or options[:categories] or options[:tease]
  movieplayer = MoviePlayer.new
  FileFinder.new.find.each do |f|
    filename = File.basename(f)
    movieplayer.play(filename)
    RenameRunner.new.run(filename, options[:actresses], options[:categories], options[:tease])
    movieplayer.stop
  end
end

if options[:move]
  MovieMover.new.move  
  FolderCleaner.new.consider_clean
end
