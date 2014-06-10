# encoding: utf-8

require_relative 'existing_videos'
require_relative '../../common/actress_name_cleaner'

class ActressesProcessor

	def initialize
		@existing_videos = ExistingVideos.new
		@name_cleaner = ActressNameCleaner.new
	end
	
	def process (current, original = "")
		
		@existing_videos.find_and_print(current)

		actresses = ""
		while actresses.length == 0
			actresses = @name_cleaner.clean Console.get_with_options("Actresses (separate by underscore)")
		end

		if actresses
			current + "_" + actresses
		else
			current
		end
	end

end