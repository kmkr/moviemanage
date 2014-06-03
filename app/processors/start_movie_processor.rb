require_relative '../movieplayer/movie_player'
require_relative '../movieplayer/remote_movie_player'

class StartMovieProcessor
	def initialize(remote)
		@movieplayer = remote ? RemoteMoviePlayer.new(remote) : MoviePlayer.new
	end
	
	def process (current, original)
		@movieplayer.play(original)
		current
	end
end