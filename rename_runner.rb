# encoding: utf-8

require_relative 'common/file_name_cleaner'
require_relative 'common/file_finder'
require_relative 'actresses/processor'
require_relative 'categories/processor'

class RenameRunner
  @@file_name_cleaner = FileNameCleaner.new
  @@actresses_processor = ActressesProcessor.new
  @@categories_processor = CategoriesProcessor.new

  def run (actresses = true, categories = true, log = false)
    FileFinder.new.find.each do |file_path|

      Thread.new do
        `killall -9 vlc`
        `vlc "#{file_path}"`
      end

      extension = File.extname (file_path)

      done = false
      until done do
        processed_name = @@file_name_cleaner.strip_ext(@@file_name_cleaner.strip_disc(file_path))
        p "========================================================================"
        p "               Checks #{file_path}"
        p "========================================================================"

        if actresses
          actresses_names = @@actresses_processor.process(processed_name)
          if consider_special_handling(file_path, actresses_names)
            done = true
            next
          end
          processed_name = "#{processed_name}_#{actresses_names}"
        end
        if categories
          categories_names = @@categories_processor.process(processed_name)
          processed_name = "#{processed_name}_#{categories_names}"
        end

        processed_name = processed_name + extension

        ctr = 1
        while File.exists?(processed_name) do
          processed_name = processed_name.gsub(/(_\(\d+\))?#{extension}/, "_(#{ctr})#{extension}")
          p "Trying #{processed_name}"
          ctr += 1
        end

        p "Rename til '#{processed_name}'? Ok? [y]/n"
        inp = gets.chomp
        done = inp.chomp == "" || inp.chomp == "y"
        if done
          File.rename file_path, processed_name
          if log
            File.open('.operations.txt', 'a') { |f| f.write("mv \"#{file_path}\" \"#{processed_name}\"\n") }
          end
        end
      end
    end
  end

  private
  def consider_special_handling (file_path, inp)
    if inp == "del"
      File.delete file_path
      p "Deleted #{file_path}"
      return true
    elsif inp == "skip"
      return true
    end
    return false
  end
end