# encoding: utf-8
require_relative '../../common/filename_cleaner'
class TxtFileHelper

	@@cleaner = FilenameCleaner.new

	def find_and_print (file_path)
		txtFileName = @@cleaner.find_txt_name(file_path)

		if File.exists? txtFileName
			p "Fant tempfil på denne fila. Printer ut innhold:"
			contents = File.open(txtFileName)
			contents.each_line do |line|
				p line
			end
		end
	end
end