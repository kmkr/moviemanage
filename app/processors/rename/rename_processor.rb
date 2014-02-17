class RenameProcessor

	def process (current, original)
		input = Console.get_input "Rename til '#{current}'? Ok? [y]/n"
		if input != "n"
			File.rename original, current
			puts "Renamed"
		end

		current
	end
end