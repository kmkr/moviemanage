require_relative '../common/name_indexifier'

class IndexifierProcessor
	def initialize
		@name_indexifier = NameIndexifier.new
	end

	def process (current, original)
		if original != current
			return @name_indexifier.indexify_if_exists(current)
		end

		return current
	end
end