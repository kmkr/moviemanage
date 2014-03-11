require_relative '../movieplayer/movie_player'
require_relative '../movieplayer/remote_movie_player'

class EndMovieProcessor
	def initialize(remote = false)
		@movieplayer = remote ? RemoteMoviePlayer.new : MoviePlayer.new
	end

	def process (current, original)
		@movieplayer.stop(current)
		current
	end
end