require_relative '../common/file_finder'
require_relative '../common/file_writer'
require_relative 'tease_file_finder'
require 'fileutils'

class MovieMover

	def initialize
		@tease_file_finder = TeaseFileFinder.new
		@movie_file_finder = FileFinder.new
		@file_writer = FileWriter.new
	end

	def move(filter = nil)
		move_tease(filter)
		move_movie(filter)
	end

	def move_tease(filter)
		tease_files = @tease_file_finder.find
		unless tease_files.any?
			puts "No tease movies found"
			return
		end

		p "Tease: Where do you want to move "
		tease_files.each_with_index do |tease_file, index|
			puts "#{index + 1}) #{tease_file}"
		end
		destination = list_and_choose(Dir["#{Settings.mover["tease_location"]}/*"], filter)

		tease_files.each do |file|
			@file_writer.move(file, "#{destination}/#{File.basename(file)}")
		end
	end

	private

	def move_movie(filter)
		files = @movie_file_finder.find(true).concat(@movie_file_finder.find(true, "scene/"))
		if files.length == 0
			p "No files to move"
			return
		end

		p "Regular: Where do you want to move "
		files.each_with_index do |file, index|
			puts "#{index + 1}) #{file}"
		end
		root = list_and_choose Settings.mover["destinations"]
		folder = list_and_choose(Dir["#{root}/*"], filter)

		files.each do |file|
			@file_writer.move(file, "#{folder}/#{File.basename(file)}")
		end
	end

	def list_and_choose (selections, filter)
		if filter.length
			matches = selections.collect { |x| x.match(filter) }
			return matches[0] if matches.length == 1
		end

		selected_destination = nil

		until selected_destination do
			selections.each_with_index do |selection, index|
				p "#{index}) #{selection}"
			end
			selected_destination = selections[gets.to_i]
		end

		selected_destination
	end
end
