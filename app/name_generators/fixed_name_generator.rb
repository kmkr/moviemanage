class FixedNameGenerator

	def initialize(fixed_name)
		@fixed_name = fixed_name
		@name_indexifier = NameIndexifier.new
	end

	def generate (original)
		extension = File.extname(original)
		filename = @fixed_name + extension
		if File.exists? filename
			puts "Warning! There is already a file called #{filename}! Continue or indexify c/[i]?"
			inp = Stdin.gets
			if inp != "c"
				return @name_indexifier.indexify_if_exists(filename)
			end
		end

		return filename
	end

end