# encoding: utf-8

require_relative '../common/file_finder'

require_relative '../common/ffmpeg_time_at_getter'
require_relative '../common/mkvmerge_time_at_getter'
require_relative '../name_generators/simple_name_generator'
require_relative 'ffmpeg_processor'
require_relative 'mkvmerge_processor'
require 'fileutils'

class Splitter

	def initialize(type = "Clip", name_generator = SimpleNameGenerator.new)
		@type = type
		@name_generator = name_generator
	end

	def process (current, original)
		while true
			times_at = determine_time_at_getter(current).get_time(@type)
			if times_at == false
				return
			end	

			splitted_name = get_target_file_name (current)

			puts "Create #{splitted_name}? [y]/n"
			inp = gets.chomp
			unless inp == "n"
				determine_movie_processor(current).split(current, times_at, splitted_name)
				clip_done = true
			end
		end

		current
	end

	private

	def get_target_file_name (original_name)
		target_file = @type.downcase + File::SEPARATOR + original_name
		@name_generator.generate(target_file)
	end

	def find_keyframes(file, start_at)
		short_file_name = "short_#{file}"

		@movie_processor.short_file file, start_at, short_file_name
		keyframes = @movie_processor.keyframes short_file_name

		keyframes.keep_if { |frame|
			frame["media_type"] == "video" and frame["key_frame"] == 1
		}.map { |frame|
			frame["pkt_pts_time"].to_f
		}
	end

	def determine_movie_processor(file)
		if file.match(/\.mkv/)
			return MkvmergeProcessor.new
		else
			return FfmpegProcessor.new
		end
	end

	def determine_time_at_getter(file)
		if file.match(/\.mkv/)
			return MkvmergeTimeAtGetter.new
		else
			return FfmpegTimeAtGetter.new
		end
	end
end
