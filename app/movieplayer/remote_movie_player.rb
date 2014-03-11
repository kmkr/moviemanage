require 'net/http'

class RemoteMoviePlayer

	def initialize
		@host = Settings.remote
	end

	def play(file_path)
		puts "Kjorer get mot #{@host}/play"
		get("#{@host}/play", file_path)
	end

	def stop(file_path)
		puts "Kjorer get mot #{@host}/stop"
		get("#{@host}/stop", file_path)
	end

	private
	def get(url, file_path)
		uri = URI(url)
		params = { :file => file_path, :wd => Dir.pwd }
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
		puts res.body if res.is_a?(Net::HTTPSuccess)
	end
end