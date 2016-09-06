require_relative '../common/settings'

class MoviePlayer

    def initialize(player)
        @player = player
    end

	def play(file_path)
		@lastpid = spawn("#{@player} \"#{file_path}\"")
		puts "Started #{file_path} with pid #{@lastpid}"
		Process.detach(@lastpid)
	end

	def stop(file_path)
		if @lastpid
			puts "Trying to stop #{@lastpid}"
			begin
				if RUBY_PLATFORM =~ /linux/
					match = `cat /proc/#{@lastpid}/cmdline`.match(/"([^"]+)/)
					unless match
						puts "No kill - didn't find process"
						return
					end
					filename =	match[1]
					`ps ax|grep "#{filename}"`.split(/\n/).each do |line|
						pid = line.match(/\A\s?\d+/)[0].strip.to_i
						puts "Killing #{pid}"
						Process.kill("HUP", pid)
					end
					`ps x |grep #{@lastpid}`.match(/vlc\s"([^"]+)/)
				else
					Process.kill("HUP", @lastpid)
					puts "Killed #{@lastpid}"
				end
			rescue Errno::ESRCH => e
				puts e
			end
		end
	end
end
