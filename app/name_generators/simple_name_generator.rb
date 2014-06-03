require_relative '../common/name_indexifier'

class SimpleNameGenerator

	def initialize(base_path = ".")
		@name_indexifier = NameIndexifier.new
		@base_path = base_path
	end

	def generate (original)
		extension = File.extname(original)
		newname = original.sub(/_\[.*/, extension)
		newname = @base_path + File::SEPARATOR + newname
		@name_indexifier.indexify_if_exists(newname)
	end

end