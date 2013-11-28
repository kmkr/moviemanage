require 'find'
require 'pathname'

vlc_bin='C:\Program Files (x86)\VideoLAN\VLC\vlc.exe'

file_paths = []
Find.find('.') do |path|
  file_paths << path if path =~ /.*\.(mkv|mp4|avi|mpeg|iso)$/
end

def strip_ext(inp)
	inp.gsub(File.extname(inp), "")
end

def strip_disc(inp)
	inp.gsub(/_disc\d+/, "")
end

def prefix_filename(path, prefix)
	fn = Pathname.new(path).basename.to_s
	path.gsub(fn, prefix + fn)
end

file_paths.each do |file_path|
	txtFileName = prefix_filename(strip_disc(strip_ext(file_path)), ".") + ".txt"
	p "Ttxfilename er #{txtFileName}"

	if File.exists? txtFileName
		p File.read(txtFileName)
	end

	pid = Process.fork {
		`"#{vlc_bin}" "#{file_path}"`
	}

	p "Actress? Sep by underscore"
	names = gets
	Process.kill pid
	p "Skrev inn #{names}"

	file_path.gsub!(/_disc\d+/, "")
	extension = File.extname(file_path)
	file_path.gsub(/#{extension}/, "_#{names}#{extension}")

	p "Rename til '#{file_path}'"

end