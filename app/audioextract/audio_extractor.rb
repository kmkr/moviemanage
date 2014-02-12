require_relative "../common/ffmpeg_time_at_getter"

class AudioExtractor

	def initialize (audio_processor = FfmpegProcessor.new)
		@audio_processor = audio_processor
		@time_at_getter = FfmpegTimeAtGetter.new
		@name_indexifier = NameIndexifier.new
	end

	def extract (file)
		done_with_file = false

		audio_name = file.sub(File.extname(file), ".mp3")

		if File.exists?("audio/#{audio_name}")
			puts "Seems like there is an audio file from this vid. "
			# todo
		end

		until done_with_file
			puts "From where/to do you want to extract #{file}?"
			start_at, end_at = @time_at_getter.get_time("Audio")

			if !start_at
				done_with_file = true
				puts "Do you want to keep #{file}? [y]/n"
				inp = gets.chomp
				if inp == "n"
					File.delete file
					puts "Deleted #{file}"
				end
				next
			end

			length_in = end_at - start_at

			puts "Sjekker om #{audio_name} finnes fra for..."
			audio_name = @name_indexifier.indexify_if_exists("audio/" + audio_name).sub("audio/", "")
			@audio_processor.audio_extract(file, start_at, length_in, audio_name)
		end
	end

end