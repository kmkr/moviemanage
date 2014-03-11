require 'socket'
require 'URI'
require 'cgi'
require_relative '../movieplayer/movie_player'

class Webserver

	def initialize
		@webserver = TCPServer.new(2000)
		@movie_player = MoviePlayer.new
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

				if request.match(/stop/)
					@movie_player.stop filename
				else
					@movie_player.play filename
				end
			else
				puts "Could not parse file from #{request}. Missing 'file' parameter?"
			end

			session.print "HTTP/1.1 204/OK\r\n"
			session.close
		end
	end
end

Webserver.new.listen