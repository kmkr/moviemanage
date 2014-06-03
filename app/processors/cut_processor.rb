require_relative '../splitter/splitter'
require_relative '../name_generators/fixed_name_generator'
require_relative '../common/file_writer'

class CutProcessor
	def initialize
		@splitter = Splitter.new(FixedNameGenerator.new("tempfile"), false)
		@file_writer = FileWriter.new
	end

	def process (current, original)
		@splitter.process(current, original)
		matches = Dir.glob("tempfile*")
		if matches.length > 1
			puts "Warning, found more than one match:"
			puts matches.inspect
			throw new "not implemented"
		elsif matches.length == 1
			puts "Found one cutted file."
			@file_writer.move(matches[0], current)
		else
			puts "No split files found!"
			throw new "not implemented"
		end

		current
	end

end