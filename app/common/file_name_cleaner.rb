require 'pathname'

class FileNameCleaner
	def strip_ext(inp)
		inp.gsub(File.extname(inp), "")
	end

	def strip_metadata(inp)
		inp.gsub(/__.*/, "")
	end

	def file_only (path)
		Pathname.new(path).basename.to_s
	end

	def find_txt_name(inp)
		prefix_filename(strip_metadata(strip_ext(inp)), ".") + ".txt"
	end

	def find_tease_name(inp)
		strip_ext(file_only(strip_metadata(inp)))
	end

	private
	def prefix_filename(path, prefix)
		fn = file_only(path)
		path.gsub(fn, prefix + fn)
	end
end