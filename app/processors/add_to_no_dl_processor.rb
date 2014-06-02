require 'fileutils'

# touches a file in location to indicate that the movie is seen, but unwanted

class AddToNoDlProcessor
	def initialize
		puts Settings.mover["tease_location"]
		puts Settings.nodl["location"]
		@reasons = Settings.nodl["reasons"]
		@location = Settings.nodl["location"]
	end

	def process (current, original = "")
		puts "Will touch #{current} in #{@location}, do you want to give a reason?"
		@reasons.each_with_index do |reason, index|
			puts "#{index+1}) #{reason}"
		end
		puts ""
		puts "(enter for no reason)"

		inp = gets.chomp
		reason = nil
		if inp =~ /\d+/
			reason = @reasons[inp.to_i-1]
		end

		touch = current + "__" + original
		if reason
			touch = touch + "_(#{reason})"
		end
		location = @location + File::SEPARATOR + touch
		FileUtils.touch(location)
		puts "Touched #{location}"

		current
	end

end