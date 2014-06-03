require 'readline'

class Stdin
	def self.gets(keep_history = false)
		Readline::readline("", keep_history)
	end
end