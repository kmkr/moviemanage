# encoding: utf-8

class FileFinder
	def find(keep_processed = false, relative_root = ".")
		file_paths = Dir.glob("*.{mkv,mp4,avi,mpeg,iso,wmv}", File::FNM_CASEFOLD)

		keep_processed ? file_paths : remove_processed(file_paths)
	end

	private
	def remove_processed (file_paths)
		file_paths.reject { |file_path |
			file_path.include? "]." or file_path.include? "]_(" or file_path.include? "tease/"
		}
	end

end