class FileWriter
	def move(src, dest)
		write = true
		if File.exists? dest
			p "File #{dest} (#{File.size(dest) / 1024} kB) exists! Overwrite with #{src} (#{File.size(src) / 1024} kB)? y/[n]"
			write = gets.chomp == "y"
		end

		if write
			puts "Moving #{src} to #{dest}"
			FileUtils.mv src, "#{dest}"
		end
	end
end