require 'fileutils'

class FolderCleaner
	def consider_clean
		files = Dir.glob("**")
		if files.length == 0
			p "Folder #{Dir.pwd} seems empty, delete? [y]/n"
			consider_del
		else
			p "Still files inside, do you still want to del?"
			files.each_with_index do |file, index|
				puts "#{index}) #{file}"
			end
			consider_del true
		end

	end

	private
	def consider_del(wipe_files = false)
		inp = Stdin.gets
		folder = Dir.pwd
		if inp == "y" or inp == ""
			if wipe_files
				Dir.glob("#{folder}/**").each do |file|
					FileUtils.rm_r file
					p "Deleted #{file}"
				end
			end
			Dir.delete(folder)
			p "Deleted #{folder}"
		else
			p "No del"
		end
	end
end