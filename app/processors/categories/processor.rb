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

		current + "_" + @categories_helper.parse(gets.chomp)
	end
end