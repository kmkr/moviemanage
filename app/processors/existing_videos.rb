
require 'find'

class ExistingVideos

	def initialize
		@locations = [ Settings.mover["tease_location"] ]
		@locations.concat(Settings.mover["destinations"])

	end

	def find_and_print (argument)
		puts "Looking for #{argument}"

		results = []
		@locations.each do |location|
			begin
				Find.find(location) do |path|
					if path =~ /.*#{argument}.*/
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
				result[:file]
				}.each do |result|
				puts "#{result[:file]} (#{result[:folder]})"
			end
		end
	end
end