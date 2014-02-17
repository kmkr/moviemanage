class ExtensionAppender
	def process (current, original)
		current + File.extname(original)
	end
end