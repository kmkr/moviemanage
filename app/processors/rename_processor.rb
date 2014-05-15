require 'fileutils'

class RenameProcessor

	def process (current, original)
		input = Console.get_input "Rename to '#{current}'? [y]/n"
		if input != "n"
			_move original, current
			puts "Renamed"
			return current
		end

		return original
	end

	private
	def _move(src, dest)
		write = true
		if File.exists? dest
			p "File #{dest} exists! Overwrite? y/[n]"
			write = gets.chomp == "y"
		end

		if write
			p "Moving #{src} to #{dest}"
			FileUtils.mv src, "#{dest}"
		end
	end
end