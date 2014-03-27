class FfmpegTimeAtGetter
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
				start_at_seconds = seconds_from_str (start_at)
				end_at_seconds = seconds_from_str (end_at)
				if start_at_seconds and end_at_seconds
					result = [ { :start_at => start_at_seconds, :ends_at => ends_at_seconds } ]
				end
			end
		end

		result
	end

	def seconds_from_str (str)
		match = str.split(/\D/)
		if match.size > 0
			seconds = match.pop
			minutes = match.pop
			hours = match.pop

			return seconds.to_i + ((minutes.to_i or 0) * 60) + ((hours.to_i or 0) * 3600)
		end

		return nil
	end
end