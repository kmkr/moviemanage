require 'fileutils'

class MovieNameProcessor

	def process(files)
		puts "Processing\n#{files.join("\n")}"
		puts ""
		puts "What's the name of the movie?"

		movie_name = gets.chomp.downcase.gsub("\s+", ".")
		files.each_with_index do |file_path, index|
			file_name = File.basename(file_path)
			new_name = "#{movie_name}__#{file_name}"
			File.rename file_path, new_name
			p "Renamed '#{file_path}' to '#{new_name}'"
		end
	end
end