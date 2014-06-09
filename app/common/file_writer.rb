class FileWriter
	def move(src, dest)
		write = true
		if File.exists? dest
			s1 = File.size(src)
			s2 = File.size(dest)
			relative = "same size"
			if s1 > s2
				relative = "#{(100*(s1.to_f/s2.to_f)).to_i}% larger"
			elsif s1 < s2
				relative = "smaller"
			end
			p "File #{dest} (#{File.size(dest) / 1024} kB) exists! Overwrite with #{src} (#{File.size(src) / 1024} kB - #{relative})? y/[n]"
			write = Stdin.gets == "y"
		end

		if write
			puts "Moving #{src} to #{dest}"
			FileUtils.mv src, "#{dest}"
		end
	end
end