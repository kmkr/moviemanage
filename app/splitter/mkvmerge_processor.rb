# encoding: utf-8

require_relative 'post_split_processor'
require_relative '../common/seconds_to_time_parser'
require_relative '../common/file_writer'

class MkvmergeProcessor

	def initialize
		@seconds_to_time_parser = SecondsToTimeParser.new(false)
		@file_writer = FileWriter.new
		@post_split_processor = PostSplitProcessor.new
	end

	def split (file, times_at, clip_name)
		if clip_name.include?(File::SEPARATOR)
			folder = clip_name.split(File::SEPARATOR)[0]
			unless File.directory?(folder)
				Dir.mkdir folder
				puts "Created '#{folder}'"
			end
		end

		# Since mkvmerge adds indexes after the filename, the indexify process
		# do not consider clip_name as existing. E.g:
		# mkvmerge splits file1.mkv into file1_001.mkv and file1_002.mkv
		# mkvmerge runs again, and file1.mkv is split into the same names and overwrites both files.
		extension = File.extname(clip_name)
		clip_name = clip_name.gsub(extension, "-" + (0...8).map { (65 + rand(26)).chr }.join + extension)

		parts = times_at_to_parts(times_at)
		# do a export LC_ALL=C in the shell
		# http://forum.synology.com/enu/viewtopic.php?f=40&t=36845&start=15

		command = "mkvmerge --split parts:#{parts} \"#{file}\" -o \"#{clip_name}\""
		Console.banner command
		system(command)

		@post_split_processor.process(times_at, clip_name)
	end

	def audio_extract (file, start_at, length_in, audio_name)
	end


	def times_at_to_parts(times_at)
		parts = ""
		times_at.each do |time_at|
			if parts.length > 0
				parts += ","
			end
			parts = parts + @seconds_to_time_parser.parse(time_at[:start_at]) + "-" + @seconds_to_time_parser.parse(time_at[:end_at])
		end

		parts
	end

end
