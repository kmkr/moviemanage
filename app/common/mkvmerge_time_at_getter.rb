require_relative 'seconds_from_string_parser'
require_relative 'actress_name_cleaner'

class MkvmergeTimeAtGetter
	def initialize
		@seconds_from_string_parser = SecondsFromStringParser.new
		@actress_name_cleaner = ActressNameCleaner.new
	end

	def get_time (type = "Extract point")
		result = nil
		while result.nil?
			puts "#{type} starts at and ends at in format <actress1<_actress2>><_[category]>@>00:01:20-00:02:45,00:05:50-00:10:30 (blank to finish)"
			inp = Stdin.gets
			if inp.empty?
				result = false
			else
				splits = inp.split(/,/)
				if splits.length
					result = []
					splits.each do |split|

						actress_info = nil
						if split.split("@").length > 1
							actress_info = @actress_name_cleaner.clean(split.split("@")[0])
							start_at, end_at = split.split("@")[1].split(/\-/)
						else
							start_at, end_at = split.split(/\-/)
						end
						puts "Start_at #{start_at} end_at #{end_at}"
						# 3:35-21.26,1.18.10-1.32.8,1.32.11-1.34.22,1.37.10-1.50.50,1.53.56-2:2:22
						if start_at and end_at
							result << {
								:actress_info => actress_info,
								:start_at => @seconds_from_string_parser.parse(start_at),
								:end_at => @seconds_from_string_parser.parse(end_at)
							}
						end
					end
				end
			end
		end
		result
	end

end