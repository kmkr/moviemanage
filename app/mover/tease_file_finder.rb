require_relative '../common/file_finder'

class TeaseFileFinder
	def initialize
		@file_finder = FileFinder.new
	end

	def find
		@file_finder.find(false)
		.concat(@file_finder.find(false, "tease"))
		.concat(@file_finder.find(false, "scene"))
	end
end