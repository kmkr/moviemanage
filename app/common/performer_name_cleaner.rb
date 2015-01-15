class PerformerNameCleaner
	def clean (performers_names)
		performers_names.gsub(/^\s/, "").gsub(/,\s?/, "_").gsub(/[\s+]/, ".").gsub(/\.+/, ".").downcase
	end
end