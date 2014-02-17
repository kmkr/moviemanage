require_relative "../../common/filename_cleaner"
class FilenameCleanerProcessor
	def initialize
		@cleaner = FilenameCleaner.new
	end

	def process (current, original = "")
		@cleaner.strip_metadata(@cleaner.strip_ext(current))
	end
end