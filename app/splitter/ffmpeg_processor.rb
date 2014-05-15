# encoding: utf-8

require 'json'
require_relative '../common/seconds_to_time_parser'

class FfmpegProcessor
	def initialize
		@seconds_to_time_parser = SecondsToTimeParser.new(true)
	end

	###
	def short_file (file, start_at, short_file_name)
		`ffmpeg -i "#{file}" -vcodec copy -acodec copy -ss #{time_to_str(start_at)} -t #{30} "#{short_file_name}"`
	end

	def keyframes (short_file_name)
		Console.banner "ffprobe -show_frames -print_format json #{short_file_name}"
		keyframes = JSON.parse(`ffprobe -show_frames -print_format json #{short_file_name}`)["frames"]
		File.delete(short_file_name)
		puts "Deleted #{short_file_name}"
		keyframes
	end
	###

	def split (file, times_at, clip_name)
		folder = clip_name.split(File::SEPARATOR)[0]
		unless File.directory?(folder)
			Dir.mkdir folder
			puts "Created '#{folder}'"
		end

		# Supports only one times_at
		start_at = @seconds_to_time_parser.parse(times_at[0][:start_at])
		length_in = @seconds_to_time_parser.parse(times_at[0][:end_at] - times_at[0][:start_at])

		command = "ffmpeg -ss #{start_at} -t #{length_in} -i \"#{file}\" -vcodec copy -acodec copy \"#{clip_name}\" -loglevel warning"
		Console.banner command
		system(command)
	end

	def audio_extract (file, start_at, length_in, audio_name)
		Dir.mkdir("audio") unless File.directory?("audio")
		command = "ffmpeg -ss #{@seconds_to_time_parser.parse(start_at)} -t #{@seconds_to_time_parser.parse(length_in)} -i \"#{file}\" -acodec libmp3lame -ab 128k \"audio/#{audio_name}\" -loglevel warning"
		Console.banner command
		system(command)
	end



end
