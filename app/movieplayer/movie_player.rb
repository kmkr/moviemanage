require_relative '../common/file_finder'
require 'fileutils'

class MoviePlayer

	def play(file_path)
		Thread.new do
			`killall -9 vlc`
			`vlc "#{file_path}"`
		end
	end

	def stop
		Thread.new do
			`killall -9 vlc`
		end
	end
end