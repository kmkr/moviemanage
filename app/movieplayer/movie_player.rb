class MoviePlayer

	def play(file_path)
		puts "Playing #{file_path}"
		@lastpid = spawn("vlc \"#{file_path}\"")
		Process.detach(@lastpid)
	end

	def stop(file_path)
		if @lastpid
			puts "Stopping #{@lastpid}"
			Process.kill("HUP", @lastpid)
		end
	end
end