require_relative 'seconds_from_string_parser'
require_relative 'performer_name_cleaner'

class FfmpegTimeAtGetter
	def initialize
		@seconds_from_string_parser = SecondsFromStringParser.new
		@performer_name_cleaner = PerformerNameCleaner.new
	end

	def get_time (type = "Extract point")
		result = nil
		while result.nil?
			puts "#{type} start at and ends at in format <performer1<_performer2>><_[category]>@>hh:mm:ss hh:mm:ss (blank to finish)"
			inp = Stdin.gets(true)
			performer_info = nil

			if inp.include?("@")
				performer_info,times = inp.split("@")
				puts times
				performer_info = @performer_name_cleaner.clean(performer_info)
				puts "AI #{performer_info}"
			else
				times = inp
			end
			times = times.split(/\s/)
			start_at = times[0]
			end_at = times[1]

			if inp.empty?
				result = false
			elsif start_at and end_at
				start_at_seconds = @seconds_from_string_parser.parse (start_at)
				end_at_seconds = @seconds_from_string_parser.parse (end_at)
				if start_at_seconds and end_at_seconds
					result = [ {
						:performer_info => performer_info,
						:start_at => start_at_seconds,
						:end_at => end_at_seconds
					} ]
				end
			end
		end

		result
	end

end
