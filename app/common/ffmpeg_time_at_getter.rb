require_relative 'seconds_from_string_parser'

class FfmpegTimeAtGetter
	def initialize
		@seconds_from_string_parser = SecondsFromStringParser.new
	end

	def get_time (type = "Extract point")
		result = nil
		while result.nil?
			puts "#{type} start at and ends at in format hh:mm:ss (blank to finish)"
			inp = gets.chomp
			times = inp.split(/\s/)
			start_at = times[0]
			end_at = times[1]
			if inp.empty?
				result = false
			elsif start_at and end_at
				start_at_seconds = @seconds_from_string_parser.parse (start_at)
				end_at_seconds = @seconds_from_string_parser.parse (end_at)
				if start_at_seconds and end_at_seconds
					result = [ { :start_at => start_at_seconds, :end_at => end_at_seconds } ]
				end
			end
		end

		result
	end

end
