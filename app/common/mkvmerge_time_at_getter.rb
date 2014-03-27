class MkvmergeTimeAtGetter
	def get_time (type = "Extract point")
		result = nil
		while result.nil?
			puts "#{type} starts at and ends at in format 00:01:20-00:02:45,00:05:50-00:10:30 (blank to finish)"
			inp = gets.chomp
			if inp.empty?
				result = false
			else
				splits = inp.split(/,/)
				if splits.length
					result = []
					splits.each do |split|
						start_at, end_at = split.split(/\-/)
						if start_at and end_at
							result << {:start_at => start_at, :end_at => end_at}
						end
					end
				end
			end
		end
		result
	end

end