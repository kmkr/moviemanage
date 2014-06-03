# encoding: utf-8

require_relative '../common/file_finder'

require_relative '../common/ffmpeg_time_at_getter'
require_relative '../common/mkvmerge_time_at_getter'
require_relative '../name_generators/simple_name_generator'
require_relative 'ffmpeg_processor'
require_relative 'mkvmerge_processor'
require 'fileutils'

class Splitter

	def initialize(name_generator, multi_run = true)
		@name_generator = name_generator
		@multi_run = multi_run
	end

	def process (current, original)
		while true
			times_at = determine_time_at_getter(current).get_time()
			if times_at == false
				return
			end	

			splitted_name = @name_generator.generate (current)

			puts "Create #{splitted_name}? [y]/n"
			inp = Stdin.gets
			unless inp == "n"
				determine_movie_processor(current).split(current, times_at, splitted_name)
			end

			return unless @multi_run
		end

		current
	end

	private

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
