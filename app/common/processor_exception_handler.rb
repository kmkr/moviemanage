class ProcessorExceptionHandler
	def handle(e)
		if e.reason == "delete"
			fn = if File.exists?(current_name) then current_name else filename end
			File.delete (fn)
			puts "Deleted #{fn}"
			return
		elsif e.reason == "skip"
			puts "Skipping #{filename}"          
			return
		elsif e.reason == "next"
			puts "Skipping current processor"
		end
	end
end