class SecondsToTimeParser
	def initialize(include_ms) 
		@include_ms = include_ms
	end

	def parse (seconds)
		ss, ms = (1000*seconds).divmod(1000)
		mm, ss = ss.divmod(60)            #=> [4515, 21]
		hh, mm = mm.divmod(60)           #=> [75, 15]
		dd, hh = hh.divmod(24)           #=> [3, 3]
		ms = ms.to_i

		hh = hh >= 10 ? hh : "0" + hh.to_s
		mm = mm >= 10 ? mm : "0" + mm.to_s
		ss = ss >= 10 ? ss : "0" + ss.to_s
		ms = ms >= 100 ? ms : (ms >= 10 ? "0" + ms.to_s : "00" + ms.to_s)
		out = "#{hh}:#{mm}:#{ss}"
		if @include_ms
			out = out + ".#{ms}"
		end
		out
	end
end