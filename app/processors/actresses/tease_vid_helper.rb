require_relative '../../common/filename_cleaner'
require 'find'

class TeaseVidHelper
	@@cleaner = FilenameCleaner.new

	def find_and_print (file_path)
		tease_file_name = @@cleaner.find_tease_name(file_path)

		results = []
		Find.find(Settings.actresses["tease_location"]) do |path|
			results << path if path =~ /.*#{tease_file_name}.*/
		end

		if results.length > 0
			p "Found tease-vids:"
			results.each do |result|
				p @@cleaner.file_only(result)
			end
		end
	end
end