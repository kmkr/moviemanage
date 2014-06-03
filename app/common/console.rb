require_relative "processor_exception"

class Console
	def self.get_input (output)
		puts "#{output} - 'del' to delete file, 'skip' to skip file, 'next' to skip processor"
		input = Stdin.gets

		if input == "del"
			raise ProcessorException.new ("delete")
		elsif input == "skip"
			raise ProcessorException.new ("skip")
		elsif input == "next"
			raise ProcessorException.new ("next")
		end

		input
	end

	def self.banner (output)
		puts "========================================================================"
		puts "               #{output}"
		puts "========================================================================"
	end

end