# encoding: utf-8
require_relative 'categories'

class CategoriesProcessor
	def initialize
		@categories_helper = Categories.new
	end
	
	def process (current, original)
		Console.get_input "Categories?"
		@categories_helper.get.each do |ac|
			p ac
		end

		current + "_" + @categories_helper.parse(gets.chomp)
	end
end