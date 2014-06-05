require 'fileutils'

require_relative '../common/file_writer'

class RenameProcessor

	def initialize
		@file_writer = FileWriter.new
	end

	def process (current, original)
		input = Console.get_with_options "From: #{original}\nTo  : #{current}\nRename? [y]/n"
		if input != "n"
			@file_writer.move(original, current)
			return current
		end

		return original
	end

end