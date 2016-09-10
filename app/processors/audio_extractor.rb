require_relative "../common/ffmpeg_time_at_getter"

class AudioExtractor

	def initialize (audio_processor = FfmpegProcessor.new)
		@audio_processor = audio_processor
		@time_at_getter = FfmpegTimeAtGetter.new
		@name_indexifier = NameIndexifier.new
	end

	def process (current, original = "")
		done_with_file = false

		audio_name = current.sub(File.extname(current), ".mp3")

		until done_with_file
			puts "From where/to do you want to extract #{current}?"

			# Supports only one time_at
			times_at = @time_at_getter.get_time("Audio")

			if !times_at
				done_with_file = true
				puts "Do you want to keep #{current}? [y]/n"
				inp = Stdin.gets
				if inp == "n"
					File.delete current
					puts "Deleted #{current}"
				end
				next
			end

            time_at = times_at[0]
			start_at = time_at[:start_at]
			end_at = time_at[:end_at]
			length_in = end_at - start_at

			puts "Sjekker om #{audio_name} finnes fra for..."
			audio_name = @name_indexifier.indexify_if_exists("audio/" + audio_name).sub("audio/", "")
			@audio_processor.audio_extract(current, start_at, length_in, audio_name)
		end

		return current
	end

end
