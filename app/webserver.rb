#!/usr/bin/ruby

require 'socket'
require 'uri'
require 'cgi'
require_relative 'movieplayer/movie_player'
require_relative 'common/settings'

class Webserver

	def initialize(settings_file)
		@webserver = TCPServer.new(2000)
		@movie_player = MoviePlayer.new
		Settings.load!(settings_file)
		@mappings = Settings.mappings
	end

	def listen
		puts "Listening on port 2000"
		while (session = @webserver.accept)
			request = session.gets
			puts "Incoming request: '#{request}'"
			params = CGI::parse(request.match(/\?([^\s]+)/)[1])
			if params and params["file"]
				filename = URI.unescape(params["file"].first)
				wd = URI.unescape(params["wd"].first)
				dir = nil
				@mappings.each do |mapping|
					puts "Matching #{wd} against #{mapping['source']}"
					if wd.match(Regexp.new(mapping["source"]))
						puts "Found #{mapping['destination']} to match #{mapping['source']}. Replacing in #{wd}"
						dir = wd.sub(Regexp.new(mapping["source"]), mapping["destination"])
						sep = File::SEPARATOR
                                                sep = Settings.separator if Settings.separator
                                                dir.gsub!(/[\\\/]/, sep)
						puts dir
						break
					end
				end

				file = filename
				if dir
					file = dir + File::SEPARATOR + filename
					file.delete!("\n")
				end

				if request.match(/stop/)
					@movie_player.stop file
				else
					@movie_player.play file
				end
			else
				puts "Could not parse file from #{request}. Missing 'file' parameter?"
			end

			session.print "HTTP/1.1 204/OK\r\n"
			session.close
		end
	end
end

config = ENV['MM_SERVER_CONFIG']
config = ARGV[0] unless config

unless config
	puts "Supply config file as argument, or set ENV['MM_SERVER_CONFIG']"
	exit
end

Webserver.new(config).listen
