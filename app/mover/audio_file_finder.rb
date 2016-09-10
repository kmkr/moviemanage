require_relative '../common/file_finder'

class AudioFileFinder
	def initialize
		@file_finder = FileFinder.new(FileFinder.audio)
	end

	def find
		@file_finder.find(false)
		.concat(@file_finder.find(false, "audio"))
	end
end
