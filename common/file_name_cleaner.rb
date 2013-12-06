require 'pathname'

class FileNameCleaner
	def strip_ext(inp)
		inp.gsub(File.extname(inp), "")
	end

	def strip_disc(inp)
		inp.gsub(/_disc\d+/, "")
	end

	def prefix_filename(path, prefix)
		fn = file_only(path)
		path.gsub(fn, prefix + fn)
	end

	def file_only (path)
		Pathname.new(path).basename.to_s
	end

	def find_txt_name(inp)
		prefix_filename(strip_disc(strip_ext(inp)), ".") + ".txt"
	end

	def find_tease_name(inp)
		strip_ext(file_only(strip_disc(inp)))
	end
end