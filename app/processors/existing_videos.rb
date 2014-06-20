
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
							:parent => tree[-3],
							:folder => tree[-2],
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
				result[:parent] + "/" + result[:folder] + "/" + result[:file]
				}.each do |result|
				printf "%-20s %-30s %s\n", result[:parent], result[:folder], result[:file]
			end
		end
	end
end