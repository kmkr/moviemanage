class ActressNameCleaner
	def clean (actresses_names)
		actresses_names.gsub(/^\s/, "").gsub(/,\s?/, "_").gsub(/[\s+]/, ".").gsub(/\.+/, ".").downcase
	end
end