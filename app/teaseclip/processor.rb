# encoding: utf-8

require_relative '../common/file_finder'
require_relative '../common/name_indexifier'
require_relative 'ffmpeg_processor'
require 'fileutils'

class TeaseClipProcessor

	def initialize(movie_processor = FfmpegProcessor.new)
		@movie_processor = movie_processor
		@name_indexifier = NameIndexifier.new
	end

	def process (file)
		tease_complete = false
		until tease_complete
			start_at, ends_at = get_time()
			if start_at == false
				return
			end	

			length_in = ends_at - start_at
			tease_name = generate_tease_name(file)
			
			#just_before, just_after = find_keyframe_alts(file, start_at)

			#puts "Du ønsket å starte på #{start_at}. Nærmeste keyframes er #{just_before} og #{just_after}"
			#puts "1) #{just_before}"
			#puts "2) #{just_after}"
			
			#keyframe = "1" == gets.chomp ? just_before : just_after

			keyframe = start_at
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
		puts "Start at #{start_at}"
		#pkt_pts_time = 29.986333
		# start_at = 30
		lastkeyframe = keyframes[0]
		just_before = nil
		just_after = nil
		puts keyframes.size
		if keyframes.size == 0
			puts "Found no video keyframes, can start at #{start_at}"
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

	def get_time
		result = nil
		while result.nil?
			puts "Tease start at and ends at in format hh:mm:ss (blank to finish)"
			inp = gets.chomp
			times = inp.split(/\s/)
			start_at = times[0]
			end_at = times[1]
			if inp.empty?
				result = false
			elsif start_at and end_at
				start_at_seconds = seconds_from_str (start_at)
				end_at_seconds = seconds_from_str (end_at)
				if start_at_seconds and end_at_seconds
					result = [
						start_at_seconds,
						end_at_seconds
					]
				end
			end
		end

		result
	end

	def seconds_from_str (str)
		match = str.split(/\D/)
		if match.size > 0
			seconds = match.pop
			minutes = match.pop
			hours = match.pop

			return seconds.to_i + (minutes or 0).to_i * 60 + (hours or 0).to_i * 3600
		end

		return nil
	end

end

