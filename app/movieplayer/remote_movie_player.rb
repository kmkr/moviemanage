require 'net/http'

class RemoteMoviePlayer

	def initialize(remote)
		@url = Settings.remote.gsub("{{num}}", remote)
	end

	def play(file_path)
		puts "GET: #{@url}/play"
		get("#{@url}/play", file_path)
	end

	def stop(file_path)
		puts "GET: #{@url}/stop"
		get("#{@url}/stop", file_path)
	end

	private
	def get(url, file_path)
		uri = URI(url)
		params = { :file => file_path, :wd => Dir.pwd }
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
	end
end