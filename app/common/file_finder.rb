require 'find'

class FileFinder
	def find(keep_processed = false)
		file_paths = []
		Find.find('.') do |path|
			file_paths << path if path =~ /.*\.(mkv|mp4|avi|mpeg|iso)$/
		end

		keep_processed ? file_paths : remove_processed(file_paths)
	end

	private
	def remove_processed (file_paths)
		file_paths.reject { |file_path |
			file_path.include? "]." or file_path.include? "]_("
		}
	end

end