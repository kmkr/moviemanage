# encoding: utf-8

require_relative '../common/file_finder'

require_relative '../common/ffmpeg_time_at_getter'
require_relative '../name_generators/simple_name_generator'
require_relative 'ffmpeg_processor'
require 'fileutils'

class Splitter

	def initialize(type = "Clip", name_generator = SimpleNameGenerator.new, movie_processor = FfmpegProcessor.new)
		@type = type
		@name_generator = name_generator
		@movie_processor = movie_processor
		@time_at_getter = FfmpegTimeAtGetter.new
	end

	def process (current, original)
		start_at, ends_at = @time_at_getter.get_time(@type)
		if start_at == false
			return
		end	

		splitted_name = get_target_file_name (current)
		if start_at > 0	
			just_before, just_after = find_keyframe_alts(current, start_at)

			puts "You requested #{start_at}. Closest keyframes are #{just_before} and #{just_after}"
			puts "1) #{just_before}"
			puts "2) #{just_after}"
			puts "Enter requested start_at in seconds"

			start_at = gets.chomp.to_f
		end

		done = false
		until done
			puts "Create #{splitted_name} from #{start_at} to #{ends_at}? [y]/n"
			inp = gets.chomp
			unless inp == "n"
				@movie_processor.split(current, start_at, ends_at - start_at, splitted_name)
				done = true
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

	def find_keyframe_alts(file, start_at)
		keyframes = find_keyframes(file, start_at)

		lastkeyframe = keyframes[0]
		just_before = nil
		just_after = nil
		puts keyframes.size
		if keyframes.size == 0
			puts "Found no video keyframes, starting at #{start_at}"
			# todo: spør om endring av til / fra i tilfelle sample er for kort
			return [ start_at, start_at ]
		else
			short_starts_on = [start_at - 15, 0].max
			keyframes.sort.each do |keyframe|
				if short_starts_on + keyframe > start_at
					if !just_before
						just_after = keyframe
						just_before = lastkeyframe
					end
				end
				lastkeyframe = keyframe
			end

			return [short_starts_on + (just_before or 0), short_starts_on + (just_after or 0)]
		end
	end
end
