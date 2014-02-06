class NameIndexifier

  def indexify_if_exists (filename)
  	extension = File.extname(filename)
  	ctr = 1
  	while File.exists?(filename) do
  		filename = filename.gsub(/(_\(\d+\))?#{extension}/, "_(#{ctr})#{extension}")
  		p "Trying #{filename}"
  		ctr += 1
  	end

  	filename
  end


end