require_relative '../common/file_finder'

class MovieNameProcessor

	def process
		p "What's the name of the movie?"
		movie_name = gets.chomp.downcase.gsub("\s+", ".")
		FileFinder.new.find.each_with_index do |file_path, index|
			new_name = "#{movie_name}_disc#{index+1}#{File.extname(file_path)}"
			File.rename file_path, new_name
			p "Renamed '#{file_path}' to '#{new_name}'"
		end
	end
end