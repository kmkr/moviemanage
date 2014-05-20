class FileWriter
	def move(src, dest)
		write = true
		if File.exists? dest
			p "File #{dest} exists! Overwrite? y/[n]"
			write = gets.chomp == "y"
		end

		if write
			puts "Moving #{src} to #{dest}"
			FileUtils.mv src, "#{dest}"
		end
	end
end