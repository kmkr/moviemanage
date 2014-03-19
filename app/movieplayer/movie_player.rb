class MoviePlayer

	def play(file_path)
		@lastpid = spawn("vlc \"#{file_path}\"")
		puts "Started #{file_path} with pid #{@lastpid}"
		Process.detach(@lastpid)
	end

	def stop(file_path)
		if @lastpid
			puts "Killing #{@lastpid}"
			begin
				if RUBY_PLATFORM =~ /linux/
					filename = `ps ax|grep #{@lastpid}`.split(/\n/).first.match(/vlc\s"([^"]+)/)[1]
					`ps x|grep "#{filename}"`.split(/\n/).each do |line|
						pid = line.match(/\A\d+/)[0].to_i
						puts "Killing #{pid}"
						Process.kill("HUP", pid)
					end
					`ps x |grep #{@lastpid}`.match(/vlc\s"([^"]+)/)
				else
					Process.kill("HUP", @lastpid)
				end
			rescue Errno::ESRCH => e
				puts e
			end
		end
	end
end