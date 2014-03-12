#!/usr/bin/ruby

require_relative '../processors/audio_extractor'
require_relative '../processors/actresses/processor'
require_relative '../processors/categories/processor'
require_relative '../processors/rename_processor'
require_relative '../splitter/splitter'
require_relative '../processors/extension_appender'
require_relative '../processors/indexifier_processor'
require_relative '../movieplayer/remote_movie_player'
require_relative '../settings'

class Repl
	def initialize
		Settings.load! "config.yml"
		@movie_player = RemoteMoviePlayer.new("100")
		@processors = [
			{ :description => "Split", :subprocessors => Splitter.new("Scene") },
			{ :description => "Extract audio", :subprocessors => AudioExtractor.new },
			{ :description => "Set actress name", :subprocessors => [ ActressesProcessor.new, IndexifierProcessor.new, ExtensionAppender.new, RenameProcessor.new ] },
			{ :description => "Set categories", :subprocessors => [ CategoriesProcessor.new, IndexifierProcessor.new, ExtensionAppender.new, RenameProcessor.new ] },
			{ :description => "Tease", :subprocessors => Splitter.new("Tease") }
		]
	end

	def start
		files = FileFinder.new.find
		files.each do |file|
			file = File.basename(file)
			puts "\e[H\e[2J"
			@movie_player.play file
			puts "What do you want to do with #{file}?"

			while true
				@processors.each_with_index do |processor, index|
					puts "#{index+1}) #{processor[:description]}"
				end
				puts ""
				puts "n) next file"

				index = get_index(@processors.length)
				next unless index

				original_name = file
				current_name = file

				processor = @processors[index]
				subprocessors = processor[:subprocessors]

				unless subprocessors.is_a?(Array)
					subprocessors = [ subprocessors ] 
				end
				subprocessors.each do |subprocessor|
					new_name = subprocessor.process(current_name, original_name)
					current_name = new_name if new_name
				end
				puts "What do you want to do next with #{file}?"
			end

			@movie_player.stop file
		end
	end

	private
	def get_index(max)
		skip = false
		until skip
			inp = gets.chomp
			if inp == "n"
				skip = true
				next
			end
			if inp =~ /\d+/ and inp.to_i <= max and inp.to_i >= 1
				return inp.to_i-1
			end
		end
	end
end

Repl.new.start