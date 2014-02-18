# encoding: utf-8

require 'json'

class FfmpegProcessor

	def short_file (file, start_at, short_file_name)
		`ffmpeg -i "#{file}" -vcodec copy -acodec copy -ss #{time_to_str(start_at)} -t #{30} "#{short_file_name}"`
	end

	def keyframes (short_file_name)
		Console.banner "ffprobe -show_frames -print_format json #{short_file_name}"
		JSON.parse(`ffprobe -show_frames -print_format json #{short_file_name}`)["frames"]
	end

	def split (file, start_at, length_in, clip_name)
		folder = clip_name.split(File::SEPARATOR)[0]
		unless File.directory?(folder)
			Dir.mkdir folder 
			puts "Created '#{folder}'"
		end

		Console.banner "ffmpeg -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} -i \"#{file}\" -vcodec copy -acodec copy \"#{clip_name}\""
		`ffmpeg -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} -i "#{file}" -vcodec copy -acodec copy "#{clip_name}"`
	end

	def audio_extract (file, start_at, length_in, audio_name)
		Dir.mkdir("audio") unless File.directory?("audio")
		Console.banner "ffmpeg -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} -i \"#{file}\" -acodec libmp3lame -ab 128k \"audio/#{audio_name}\""
		`ffmpeg -ss #{time_to_str(start_at)} -t #{time_to_str(length_in)} -i "#{file}" -acodec libmp3lame -ab 128k "audio/#{audio_name}"`
	end

	def time_to_str (seconds)
		ss, ms = (1000*seconds).divmod(1000)
		mm, ss = ss.divmod(60)            #=> [4515, 21]
		hh, mm = mm.divmod(60)           #=> [75, 15]
		dd, hh = hh.divmod(24)           #=> [3, 3]
		ms = ms.to_i

		hh = hh >= 10 ? hh : "0" + hh.to_s
		mm = mm >= 10 ? mm : "0" + mm.to_s
		ss = ss >= 10 ? ss : "0" + ss.to_s
		ms = ms >= 100 ? ms : (ms >= 10 ? "0" + ms.to_s : "00" + ms.to_s)
		"#{hh}:#{mm}:#{ss}.#{ms}"
	end

end
