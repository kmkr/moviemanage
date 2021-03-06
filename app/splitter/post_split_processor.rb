require_relative '../common/file_writer'
require_relative '../common/name_indexifier'

class PostSplitProcessor
	def initialize
		@file_writer = FileWriter.new
		@name_indexifier = NameIndexifier.new
	end

	def process(times_at, original_clip_name)
		without_extension = original_clip_name.sub(File.extname(original_clip_name), "")
		output = Dir.glob(without_extension + "*").sort

		times_at.each_with_index do |time_at, index|
			performer_info = time_at[:performer_info]
			if performer_info
				puts "Found performer info for part #{index})"
				filename = output[index]
				if filename
					extension = File.extname(filename)
					renamed = @name_indexifier.indexify_if_exists(output[index].sub(/__.*/, "").sub(extension, "") + "_" + performer_info + extension)

					done = false

					until done
						puts "From: #{filename}"
						puts "To  : #{renamed}"
						puts "Rename? [y]/n?"
						inp = Stdin.gets
						if inp == "skip"
							done = true
						elsif inp != "n"
							@file_writer.move(filename, renamed)
							done = true
						end
					end
				else
					"Found #{performer_info} but output is wrong size! #{output.inspect}"
				end
			else
				puts "Did not find performer_info"
			end
		end
	end

end