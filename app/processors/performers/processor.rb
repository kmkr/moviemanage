# encoding: utf-8

require_relative '../../common/performer_name_cleaner'

class PerformersProcessor

	def initialize
		@name_cleaner = PerformerNameCleaner.new
	end
	
	def process (current, original = "")

		performers = ""
		while performers.length == 0
			performers = @name_cleaner.clean Console.get_with_options("Performers (separate by underscore)")
		end

		if performers
			current + "_" + performers
		else
			current
		end
	end

end