# encoding: utf-8
require_relative 'post_split_processor'
require_relative '../common/seconds_to_time_parser'

class FfmpegProcessor
	def initialize
		@seconds_to_time_parser = SecondsToTimeParser.new(true)
		@post_split_processor = PostSplitProcessor.new
	end

	def split (file, times_at, clip_name)
		if clip_name.include?(File::SEPARATOR)
			folder = clip_name.split(File::SEPARATOR)[0]
			unless File.directory?(folder)
				Dir.mkdir folder
				puts "Created '#{folder}'"
			end
		end

		# Supports only one times_at
		start_at = @seconds_to_time_parser.parse(times_at[0][:start_at])
		length_in = @seconds_to_time_parser.parse(times_at[0][:end_at] - times_at[0][:start_at])

		command = determine_command(start_at, length_in, file, clip_name)
		Console.banner command
		system(command)

		@post_split_processor.process(times_at, clip_name)
	end

	def audio_extract (file, start_at, length_in, audio_name)
		Dir.mkdir("audio") unless File.directory?("audio")
		command = "ffmpeg -ss #{@seconds_to_time_parser.parse(start_at)} -t #{@seconds_to_time_parser.parse(length_in)} -i \"#{file}\" -acodec libmp3lame -ab 128k \"audio/#{audio_name}\" -loglevel warning"
		Console.banner command
		system(command)
	end

	private
	def determine_command (start_at, length_in, file, clip_name)
		if which 'ffmpeg'
			return  "ffmpeg -ss #{start_at} -t #{length_in} -i \"#{file}\" -vcodec copy -acodec copy \"#{clip_name}\" -loglevel warning"
		elsif which 'avconv'
			return "avconv -i \"#{file}\" -vcodec copy -acodec copy -ss #{start_at} -t #{length_in} \"#{clip_name}\" -loglevel warning"
		else
			raise 'Did not find neither ffmpeg nor avconv on path. Requires one of them'
		end
	end
	def which(cmd)
  		exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  		ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    			exts.each { |ext|
      				exe = File.join(path, "#{cmd}#{ext}")
	      			return exe if File.executable?(exe) && !File.directory?(exe)
    			}
  		end
  		return nil
	end

end
