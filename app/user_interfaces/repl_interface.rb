#!/usr/bin/ruby

require_relative '../processors/audio_extractor'
require_relative '../processors/add_to_no_dl_processor'
require_relative '../processors/actresses/processor'
require_relative '../processors/categories/processor'
require_relative '../processors/rename_processor'
require_relative '../processors/filename_cleaner_processor'
require_relative '../splitter/splitter'
require_relative '../processors/extension_appender'
require_relative '../processors/delete_or_keep_processor'
require_relative '../processors/indexifier_processor'
require_relative '../processors/cut_processor'
require_relative '../common/processor_exception'
require_relative '../common/processor_exception_handler'
require_relative '../stdin/stdin'

class ReplInterface
	def initialize
		@tasks = [
			{ :description => "Split", :processors => Splitter.new(SimpleNameGenerator.new("scene")) },
			{ :description => "Extract audio", :processors => AudioExtractor.new },
			{ :description => "Set actress name", :processors => [ FilenameCleanerProcessor.new, ActressesProcessor.new, ExtensionAppender.new, IndexifierProcessor.new, RenameProcessor.new ] },
			{ :description => "Set categories", :processors => [ FilenameCleanerProcessor.new, CategoriesProcessor.new, ExtensionAppender.new, IndexifierProcessor.new, RenameProcessor.new ] },
			{ :description => "Tease", :processors => Splitter.new(SimpleNameGenerator.new("tease")) },
			{ :description => "Delete", :processors => DeleteOrKeepProcessor.new },
			{ :description => "Cut (use single part of movie)", :processors => CutProcessor.new },
			{ :description => "Add to NO DL", :processors => AddToNoDlProcessor.new }
		]
	end

	def run (filename, options)
		#puts "\e[H\e[2J"

		current_name = filename
		last_name = filename
		while true
			puts "What do you want to do with #{current_name}?"
			@tasks.each_with_index do |processor, index|
				puts "#{index+1}) #{processor[:description]}"
			end
			puts ""
			puts "n) next file"

			index = get_index(@tasks.length)
			return unless index

			task = @tasks[index]
			processors = task[:processors]

			processors = [ processors ]  unless processors.is_a?(Array)

			processors.each do |processor|
				new_name = false
				begin
					new_name = processor.process(current_name, last_name)
				rescue ProcessorException => e
					ProcessorExceptionHandler.new.handle(e, current_name, last_name)
				end
				current_name = new_name if new_name
			end

			last_name = current_name
		end
	end

	private
	def get_index(max)
		skip = false
		until skip
			inp = Stdin.gets
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
