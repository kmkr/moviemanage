require_relative '../mover/movie_mover'

class MoveCurrentFileProcessor
	def initialize
		@movie_mover = MovieMover.new
	end

	def process (current, original)
		@movie_mover.move([current])

		current
	end
end
