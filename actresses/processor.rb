# encoding: utf-8

require_relative 'txt_file_helper'
require_relative 'tease_vid_helper'
require_relative 'actress_name_cleaner'

class ActressesProcessor

	@@txt_file_helper = TxtFileHelper.new
	@@tease_vid_helper = TeaseVidHelper.new
	@@name_cleaner = ActressNameCleaner.new
	
	def process (file_path)
		
		@@txt_file_helper.find_and_print(file_path)
		@@tease_vid_helper.find_and_print(file_path)

		p "Actresses (separate by underscore) (del for delete, skip for next)"
		actresses = ""
		while actresses.length == 0
			actresses = @@name_cleaner.clean gets.chomp
		end

		actresses
	end

end