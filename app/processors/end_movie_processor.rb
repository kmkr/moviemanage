require_relative '../movieplayer/movie_player'

class EndMovieProcessor
	def initialize
		@movieplayer = MoviePlayer.new
	end
	def process (current, original)
		@movieplayer.stop
		current
	end
end