# encoding: utf-8

require_relative '../common/file_finder'
require_relative '../common/name_indexifier'
require_relative '../common/ffmpeg_time_at_getter'
require_relative 'ffmpeg_processor'
require 'fileutils'

class TeaseClipProcessor

	def initialize(movie_processor = FfmpegProcessor.new)
		@movie_processor = movie_processor
		@name_indexifier = NameIndexifier.new
		@time_at_getter = FfmpegTimeAtGetter.new
	end

	def process (file)
		tease_complete = false
		until tease_complete
			start_at, ends_at = @time_at_getter.get_time("Tease")
			if start_at == false
				return
			end	

			length_in = ends_at - start_at
			tease_name = generate_tease_name(file)
		
			if start_at > 0	
				just_before, just_after = find_keyframe_alts(file, start_at)

				puts "You requested #{start_at}. Closest keyframes are #{just_before} and #{just_after}"
				puts "1) #{just_before}"
				puts "2) #{just_after}"
				puts "Enter requested start_at in seconds"
				
				keyframe = gets.chomp.to_f
			else
				keyframe = start_at
			end

			done = false
			until done
				puts "Create #{tease_name}? [y]/n"
				inp = gets.chomp
				unless inp == "n"
					done = true
					@movie_processor.tease(file, keyframe, length_in, tease_name)
				end
			end
		end
	end

	private

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

			puts "JB #{just_before} JA #{just_after}"
			return [short_starts_on + (just_before or 0), short_starts_on + (just_after or 0)]
		end
	end

	def generate_tease_name (original)
		extension = File.extname(original)
		newname = original.sub(/_\[.*/, extension)
		@name_indexifier.indexify_if_exists(newname)
	end

	

end

