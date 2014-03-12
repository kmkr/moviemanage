class MoviePlayer

	def play(file_path)
		puts "Playing #{file_path}"
		@lastpid = spawn("vlc \"#{file_path}\"")
		Process.detach(@lastpid)
	end

	def stop(file_path)
		if @lastpid
			puts "Killing #{@lastpid}"
			begin
				Process.kill("HUP", @lastpid)
			rescue Errno::ESRCH => e
				puts e
			end
		end
	end
end