require_relative '../common/file_finder'

class MovieMover

	def move
		files = FileFinder.new.find(true)
		if files.length == 0
			p "No files to move"
			return
		end

		p "Where do you want to move #{files.inspect} ?"
		root = list_and_choose Settings.mover["destinations"]
		folder = list_and_choose Dir["#{root}/*"]

		files.each do |file|
			File.rename file, "#{folder}/#{file}"
			p "Moved #{file} to #{folder}/"
		end
	end

	private

	def list_and_choose (selections)
		selected_destination = nil

		until selected_destination do
			selections.each_with_index do |selection, index|
				p "#{index}) #{selection}"
			end
			selected_destination = selections[gets.to_i]
		end

		selected_destination
	end
end