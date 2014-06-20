
require 'find'

class ExistingVideos

	def initialize
		@locations = Settings.scanner["locations"]
		@locations << Settings.mover["tease_location"] if Settings.scanner["tease"]
		@locations << Settings.nodl["location"] if Settings.scanner["nodl"]
		@locations.concat(Settings.mover["destinations"]) if Settings.scanner["mover"]
	end

	def find_and_print (argument)
		puts "Looking for #{argument}"

		results = []
		@locations.each do |location|
			begin
				Find.find(location) do |path|
					if path.downcase =~ /.*#{argument}.*/
						tree = path.split(File::SEPARATOR)
						results << {
							:folder => "#{tree[-3]}/#{tree[-2]}",
							:file => tree[-1]
						} 
					end
				end
			rescue Errno::ENOENT => e
				puts "Error while scanning #{location}: #{e}"
			end
		end

		if results.length > 0
			puts "Found vids:"
			results.sort_by{ |result|
				result[:folder] + "/" + result[:file]
				}.each do |result|
				puts "#{result[:folder]}\t#{result[:file]}"
			end
		end
	end
end