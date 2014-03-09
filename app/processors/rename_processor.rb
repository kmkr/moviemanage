class RenameProcessor

	def process (current, original)
		input = Console.get_input "Rename to '#{current}'? [y]/n"
		if input != "n"
			File.rename original, current
			puts "Renamed"
		end

		current
	end
end