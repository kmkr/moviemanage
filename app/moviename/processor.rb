require 'fileutils'

class MovieNameProcessor

	def process(files, name)
		puts "Processing\n#{files.join("\n")}"
		puts ""

		if name.size > 5
			movie_name = name
		else
			puts "What's the name of the movie?"
			movie_name = Stdin.gets(true).downcase.gsub("\s+", ".")
		end
		files.each_with_index do |file_path, index|
			file_name = File.basename(file_path)
			new_name = "#{movie_name}__#{file_name}"
			File.rename file_path, new_name
			p "Renamed '#{file_path}' to '#{new_name}'"
		end
	end
end