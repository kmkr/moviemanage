require 'find'

class FileFinder
	def find(keep_processed = false, relative_root = ".")
		file_paths = []
		begin
			Find.find(relative_root) do |path|
				file_paths << path if path =~ /.*\.(mkv|mp4|avi|mpeg|iso|wmv)$/ and path !~ /short_/
			end
		rescue Errno::ENOENT => e
			puts e
		end

		keep_processed ? file_paths : remove_processed(file_paths)
	end

	private
	def remove_processed (file_paths)
		file_paths.reject { |file_path |
			file_path.include? "]." or file_path.include? "]_(" or file_path.include? "tease/"
		}
	end

end