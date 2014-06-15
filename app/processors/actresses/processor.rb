# encoding: utf-8

require_relative '../../common/actress_name_cleaner'

class ActressesProcessor

	def initialize
		@name_cleaner = ActressNameCleaner.new
	end
	
	def process (current, original = "")

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