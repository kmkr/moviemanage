require_relative "../common/console"

class DeleteOrKeepProcessor
	def process (current, original)
		Console.get_input ("Delete or keep #{current}?")
	end
end