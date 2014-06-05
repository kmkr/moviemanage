require_relative "../common/console"

class DeleteOrKeepProcessor
	def process (current, original)
		Console.get_with_options ("Delete or keep #{current}?")
	end
end