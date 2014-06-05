# encoding: utf-8

require_relative 'txt_file_helper'
require_relative 'tease_vid_helper'
require_relative '../../common/actress_name_cleaner'

class ActressesProcessor

	def initialize
		@txt_file_helper = TxtFileHelper.new
		@tease_vid_helper = TeaseVidHelper.new
		@name_cleaner = ActressNameCleaner.new
	end
	
	def process (current, original = "")
		
		@txt_file_helper.find_and_print(current)
		@tease_vid_helper.find_and_print(current)

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