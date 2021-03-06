require_relative 'categories'

class CategoriesProcessor
	def initialize
		@categories_helper = Categories.new
	end
	
	def process (current, original)
		puts "Categories?"
		@categories_helper.get.each do |ac|
			puts ac
		end

		categories_str = @categories_helper.parse(Stdin.gets)
		if categories_str.length > 0
			current + "_" + categories_str
		else
			current
		end
	end
end