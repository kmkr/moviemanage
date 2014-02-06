# encoding: utf-8

require_relative '../common/file_finder'
require_relative 'ffmpeg_processor'
require 'fileutils'

class TeaseClipProcessor

	def initialize(movie_processor = FfmpegProcessor.new)
		@movie_processor = movie_processor
	end

	def process (file)
		start_at = get_time("start at")
		length_in = get_time("length in")
		tease_name = generate_tease_name(file)
		just_before, just_after = find_keyframe_alts(file, start_at)

		
		puts "Du ønsket å starte på #{start_at}. Nærmeste keyframes er #{just_before} og #{just_after}"
		puts "1) #{just_before}"
		puts "2) #{just_after}"
		
		keyframe = "1" == gets.chomp ? just_before : just_after

		done = false
		until done
			puts "Create #{tease_name}?"
			if gets.chomp == "y" or gets.chomp == ""
				done = true
				@movie_processor.tease(file, keyframe, length_in, tease_name)
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
		puts "Start at #{start_at}"
		#pkt_pts_time = 29.986333
		# start_at = 30
		lastkeyframe = keyframes[0]
		just_before = nil
		just_after = nil
		puts "Found #{keyframes.size} video keyframes"
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
		[short_starts_on + just_before, short_starts_on + just_after]
	end

	def generate_tease_name (original)
		extension = File.extname(original)
		puts "Creating tease name from #{original}"
		newname = original.sub(/_\[.*/, extension)
		while File.exists?(newname)
			newname = newname.sub(extension, "_tease" + extension)
		end
		newname
	end

	def get_time(type)
		result = nil
		until result
			puts "Tease #{type} hh:mm:ss"
			inp = gets.chomp
			puts "sjekker '#{inp}'"
			match = inp.match(/\A(\d{2}):(\d{2}):(\d{2})\Z/)
			if match
				result = match[3].to_i + (match[2].to_i * 60) + (match[1].to_i * 3600)
			end
		end

		result
	end

end

