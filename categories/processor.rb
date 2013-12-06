# encoding: utf-8
require_relative 'categories'

class CategoriesProcessor
	@@categories_helper = Categories.new
	
	def process (file_path)
		p "Categories?"
		@@categories_helper.get.each do |ac|
			p ac
		end

		@@categories_helper.parse(gets.chomp)
	end
end