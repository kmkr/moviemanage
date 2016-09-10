# encoding: utf-8

class FileFinder
	@@types = {
		:movie => '*.{mkv,mp4,avi,mpeg,iso,wmv}',
		:audio => '*.{mp3,wav,wma,flac,ogg}'
	}

	def initialize(type = :movie)
		@extensions = @@types[type]
	end

	def find(keep_processed = false, relative_root = ".")
		file_paths = Dir.glob("#{relative_root}/#{@extensions}", File::FNM_CASEFOLD).sort

		keep_processed ? file_paths : remove_processed(file_paths)
	end

	def self.audio
		:audio
	end

	private
	def remove_processed (file_paths)
		file_paths.reject { |file_path |
			file_path.include? "]." or file_path.include? "]_("
		}
	end

end
