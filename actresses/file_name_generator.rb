class FileNameHelper
	def generate (inp)
		remove_crap(inp)
	end

	def insert_at_end (file_path, to_insert)
		extension = File.extname(file_path)
		file_path.gsub(/#{extension}/, "_#{to_insert}#{extension}")
	end

	private

	def remove_crap(file_path)
		file_path.gsub(/_disc\d+/, "")
	end

end