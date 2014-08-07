require_relative 'existing_videos'

class ExistingVideosProcessor
	def initialize
		@existing_videos = ExistingVideos.new
	end

	def process (current, original)
		@existing_videos.find_and_print current

		current
	end
end