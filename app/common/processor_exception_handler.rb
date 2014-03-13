class ProcessorExceptionHandler
	def handle(e, *filename_candidates)
		if e.reason == "delete"
			filename_candidates.each do |fc|
				if File.exists?(fc)
					File.delete (fc)
					puts "Deleted #{fc}"
					return
				end
			end
		elsif e.reason == "skip"
			puts "Skipping #{filename}"          
			return
		elsif e.reason == "next"
			puts "Skipping current processor"
		end
	end
end