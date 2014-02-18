require_relative '../movieplayer/movie_player'

class StartMovieProcessor
	def initialize
		@movieplayer = MoviePlayer.new
	end
	def process (current, original)
		@movieplayer.play(original)
		current
	end
end