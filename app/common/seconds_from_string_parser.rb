class SecondsFromStringParser

	def parse (str)
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