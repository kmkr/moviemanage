require_relative '../common/name_indexifier'

class SimpleNameGenerator

	def initialize
		@name_indexifier = NameIndexifier.new
	end

	def generate (original)
		extension = File.extname(original)
		newname = original.sub(/_\[.*/, extension)
		@name_indexifier.indexify_if_exists(newname)
	end

end