# encoding: utf-8

require 'json'

class MkvmergeProcessor

	def split (file, times_at, clip_name)
		folder = clip_name.split(File::SEPARATOR)[0]
		unless File.directory?(folder)
			Dir.mkdir folder
			puts "Created '#{folder}'"
		end

		parts = times_at_to_parts(times_at)
		# do a export LC_ALL=C in the shell
		# http://forum.synology.com/enu/viewtopic.php?f=40&t=36845&start=15

		command = "mkvmerge --split parts:#{parts} \"#{file}\" -o \"#{clip_name}\""
		Console.banner command
		system(command)
	end

	def audio_extract (file, start_at, length_in, audio_name)
	end

	private

	def times_at_to_parts(times_at)
		parts = ""
		times_at.each do |time_at|
			if parts.length > 0
				parts += ","
			end
			parts = parts + time_at[:start_at] + "-" + time_at[:end_at]
		end

		parts
	end

end
