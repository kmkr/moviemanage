require_relative '../common/file_finder'
require_relative '../common/file_writer'
require_relative 'audio_file_finder'
require_relative 'tease_file_finder'
require 'fileutils'

class MovieMover

	def initialize
		@tease_file_finder = TeaseFileFinder.new
		@movie_file_finder = FileFinder.new
		@audio_file_finder = AudioFileFinder.new
		@file_writer = FileWriter.new
	end

	def auto_move(destination_filter = "")
		move_audio(destination_filter)
		move_tease(destination_filter)
		regular_files = @movie_file_finder.find(true).concat(@movie_file_finder.find(true, "scene/"))
		move(regular_files, destination_filter)
	end

	def move(files, destination_filter = "")
		move_movie(files, destination_filter)
	end

	private
	def move_audio(destination_filter)
		audio_file = @audio_file_finder.find
		unless audio_file.any?
			puts "No audio files found"
			return
		end

        audio_loc = Settings.mover["audio_location"]
        if !audio_loc
                p "Missing audio location in settings file"
                return
        end
		destination = "#{audio_loc}/"

		p "Audio: will move to static location #{destination} "
		audio_file.each_with_index do |audio_file, index|
			puts "#{index + 1}) #{audio_file}"
		end
		
		audio_file.each do |file|
			@file_writer.move(file, "#{destination}/#{File.basename(file)}")
		end
	end

	def move_tease(destination_filter)
		tease_files = @tease_file_finder.find
		unless tease_files.any?
			puts "No tease movies found"
			return
		end

		p "Tease: Where do you want to move "
		tease_files.each_with_index do |tease_file, index|
			puts "#{index + 1}) #{tease_file}"
		end
		destination = list_and_choose(Dir["#{Settings.mover["tease_location"]}/*"], destination_filter)

		tease_files.each do |file|
			@file_writer.move(file, "#{destination}/#{File.basename(file)}")
		end
	end

	def move_movie(files, destination_filter)
		if files.length == 0
			p "No files to move"
			return
		end

		p "Regular: Where do you want to move "
		files.each_with_index do |file, index|
			puts "#{index + 1}) #{file}"
		end
		root = list_and_choose Settings.mover["destinations"]
		folder = list_and_choose(Dir["#{root}/*"], destination_filter)

		files.each do |file|
			@file_writer.move(file, "#{folder}/#{File.basename(file)}")
		end
	end

	def list_and_choose (selections, destination_filter = "")
		if destination_filter.size > 0
			matches = selections.select { |x| x.match(destination_filter) }
            puts "Matched #{matches}"
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
