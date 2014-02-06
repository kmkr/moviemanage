# encoding: utf-8

require_relative 'common/file_name_cleaner'
require_relative 'common/name_indexifier'
require_relative 'actresses/processor'
require_relative 'categories/processor'
require_relative 'teaseclip/processor'

class RenameRunner
  @@file_name_cleaner = FileNameCleaner.new
  @@actresses_processor = ActressesProcessor.new
  @@categories_processor = CategoriesProcessor.new
  @@tease_processor = TeaseClipProcessor.new
  @@name_indexifier = NameIndexifier.new
  def run (filename, actresses = true, categories = true, tease = true)
    extension = File.extname (filename)

    done = false
    until done do
      processed_name = @@file_name_cleaner.strip_metadata(@@file_name_cleaner.strip_ext(filename))
      p "========================================================================"
      p "               Checks #{filename}"
      p "========================================================================"

      if actresses
        actresses_names = @@actresses_processor.process(processed_name)
        if consider_special_handling(filename, actresses_names)
          done = true
          next
        end
        processed_name = "#{processed_name}_#{actresses_names}"
      end

      if categories
        processed_name = get_categories_name(processed_name)
      end

      processed_name = processed_name + extension

      if processed_name != filename
        processed_name = @@name_indexifier.indexify_if_exists(processed_name)

        p "Rename til '#{processed_name}'? Ok? [y]/n"
        inp = gets.chomp
        done = inp.chomp == "" || inp.chomp == "y"
        if done
          File.rename filename, processed_name
        end
      end

      if tease
        @@tease_processor.process(processed_name)
      end

      puts "Behold eller slett? Skriv 'del' for å slette"
      consider_special_handling(processed_name, gets.chomp)
    end
  end

  private
  def consider_special_handling (filename, inp)
    if inp == "del"
      File.delete filename
      p "Deleted #{filename}"
      return true
    elsif inp == "skip"
      return true
    end
    return false
  end

  def get_categories_name (input)
    categories_names = @@categories_processor.process(input)
    "#{input}_#{categories_names}"
  end

end