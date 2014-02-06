# encoding: utf-8

require 'json'

class FfmpegProcessor

	def short_file (file, start_at, short_file_name)
		`ffmpeg -i "#{file}" -vcodec copy -acodec copy -ss #{time_to_str(start_at)} -t #{30} "#{short_file_name}"`
	end

	def keyframes (short_file_name)
		puts "======================================================================"
		puts ""
		puts "ffprobe -show_frames -print_format json #{short_file_name}"
		puts ""
		puts "======================================================================"
		JSON.parse(`ffprobe -show_frames -print_format json #{short_file_name}`)["frames"]
	end

	def tease (file, start_at, length_in, tease_name)
		Dir.mkdir("tease") unless File.directory?("tease")
		puts "======================================================================"
		puts ""
		puts "ffmpeg -i \"#{file}\" -g 1 -vcodec copy -acodec copy -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} \"tease/#{tease_name}\""
		puts ""
		puts "======================================================================"
		puts "start_at: #{start_at} tts: #{time_to_str(start_at)} length_in: #{length_in}"
		`ffmpeg -i "#{file}" -g 1 -vcodec copy -acodec copy -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} "tease/#{tease_name}"`
	end

	private
	def time_to_str (seconds)
		puts "sjekker #{seconds}"
		ss, ms = (1000*seconds).divmod(1000)
		mm, ss = ss.divmod(60)            #=> [4515, 21]
		hh, mm = mm.divmod(60)           #=> [75, 15]
		dd, hh = hh.divmod(24)           #=> [3, 3]
		ms = ms.to_i

		# must start close to the keyframe, starting at the keyframe would be too late and force the player
		# to wait until next keyframe before showing video
		if ms > 50
			ms = ms - 50
		else
			if ss > 0
				ss = ss - 1
				ms = ms + 950
			end
		end

		hh = hh >= 10 ? hh : "0" + hh.to_s
		mm = mm >= 10 ? mm : "0" + mm.to_s
		ss = ss >= 10 ? ss : "0" + ss.to_s
		ms = ms >= 100 ? ms : (ms >= 10 ? "0" + ms.to_s : "00" + ms.to_s)
		"#{hh}:#{mm}:#{ss}.#{ms}"
	end

end
