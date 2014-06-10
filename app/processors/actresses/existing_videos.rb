require_relative '../../common/filename_cleaner'
require 'find'

class ExistingVideos

	def initialize
		@locations = [ Settings.mover["tease_location"] ]
		@locations.concat(Settings.mover["destinations"])
		@cleaner = FilenameCleaner.new
	end

	def find_and_print (file_path)
		tease_file_name = @cleaner.find_tease_name(file_path)

		results = []
		@locations.each do |location|
			begin
				Find.find(location) do |path|
					results << path if path =~ /.*#{tease_file_name}.*/
				end
			rescue Errno::ENOENT => e
				puts "Error while scanning #{location}: #{e}"
			end
		end

		if results.length > 0
			puts "Found vids:"
			results.sort.each do |result|
				puts @cleaner.file_only(result)
			end
		end
	end
end