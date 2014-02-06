require_relative '../common/file_finder'
require 'fileutils'

class MovieMover

	def move
		move_tease
		move_movie
	end

	def move_tease
		tease_files = FileFinder.new.find(true, "tease/")
		unless tease_files.any?
			puts "No tease movies found"
			return
		end

		p "Where do you want to move "
		tease_files.each_with_index do |tease_file, index|
			puts "#{index + 1}) #{tease_file}"
		end
		destination = list_and_choose Dir["#{Settings.mover["tease_location"]}/*"]

		tease_files.each do |file|
			p "Moving #{file} to #{destination}/"
			FileUtils.mv file, "#{destination}/#{File.basename(file)}"
		end
	end

	private
	def move_movie
		files = FileFinder.new.find(true)
		if files.length == 0
			p "No files to move"
			return
		end

		p "Where do you want to move "
		files.each_with_index do |file, index|
			puts "#{index + 1}) #{file}"
		end
		root = list_and_choose Settings.mover["destinations"]
		folder = list_and_choose Dir["#{root}/*"]

		files.each do |file|
			p "Moving #{file} to #{folder}/"
			FileUtils.mv file, "#{folder}/#{file}"
		end
	end

	def list_and_choose (selections)
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