class Categories
	def get
		Settings.categories
	end

	def parse(inp)
		str = ""

		Settings.categories.each do |category|
			letter = category.match(/\[(\w)\]/)[1]
			p "Sjekker #{category} ved a se om #{letter} er i #{inp}"
			str += "[#{category.gsub(/[\[\]]/, "")}]" if inp.include? letter
		end

		str
	end
end