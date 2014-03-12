#!/usr/bin/ruby

require 'socket'
require 'uri'
require 'cgi'
require_relative 'movieplayer/movie_player'
require_relative 'settings'

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
					if wd.match(Regexp.new(mapping["source"]))
						puts "Found #{mapping['destination']} to match #{mapping['source']}. Replacing in #{wd}"
						dir = wd.sub(Regexp.new(mapping["source"]), mapping["destination"])
						dir.gsub!(/[\\\/]/, File::SEPARATOR)
						puts dir
						break
					end
				end

				file = filename
				if dir
					file = dir + File::SEPARATOR + filename
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

unless ARGV[0]
	puts "Supply config file"
	exit
end

Webserver.new(ARGV[0]).listen