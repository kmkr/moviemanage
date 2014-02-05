class FolderCleaner
	def consider_clean
		files = Dir.glob("**")
		if files.length == 0
			p "Folder #{Dir.pwd} seems empty, delete? [y]/n"
			consider_del
		else
			p "Still files #{files.inspect} inside, do you still want to del?"
			consider_del true
		end

	end

	private
	def consider_del(wipe_files = false)
		inp = gets.chomp
		folder = Dir.pwd
		if inp == "y" or inp == ""
			if wipe_files
				Dir.glob("#{folder}/*").each do |file|
					File.delete file
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