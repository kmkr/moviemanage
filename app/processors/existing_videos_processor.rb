require_relative 'existing_videos'
require_relative '../common/filename_cleaner'

class ExistingVideosProcessor
	def initialize
		@existing_videos = ExistingVideos.new
		@cleaner = FilenameCleaner.new
	end

	def process (current, original)
		@existing_videos.find_and_print @cleaner.find_tease_name(current)

		current
	end
end