require_relative '../common/file_writer'

class PostSplitProcessor
	def initialize
		@file_writer = FileWriter.new
	end

	def process(times_at, original_clip_name)
		without_extension = original_clip_name.sub(File.extname(original_clip_name), "")
		output = Dir.glob(without_extension + "*")

		times_at.each_with_index do |time_at, index|
			actress_info = time_at[:actress_info]
			if actress_info
				puts "Found actress info for part #{index})"
				filename = output[index]
				if filename
					extension = File.extname(filename)
					renamed = output[index].sub(/__.*/, "_") + actress_info + extension

					done = false

					until done
						puts "Rename #{filename} to #{renamed} [y]/n?"
						inp = Stdin.gets
						if inp == "n"
							renamed = Stdin.gets
						elsif inp == "skip"
							done = true
						else
							@file_writer.move(filename, renamed)
							done = true
						end
					end
				else
					"Found #{actress_info} but output is wrong size! #{output.inspect}"
				end
			else
				puts "Did not find actress_info"
			end
		end
	end

end