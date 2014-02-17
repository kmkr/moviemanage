# encoding: utf-8

require_relative 'common/filename_cleaner'
require_relative 'common/console'
require_relative 'common/processor_exception'

require_relative 'audioextract/audio_extractor'
require_relative 'processors/filename_cleaner/filename_cleaner_processor'
require_relative 'actresses/processor'
require_relative 'categories/processor'
require_relative 'processors/rename/rename_processor'
require_relative 'splitter/splitter'
require_relative 'processors/extension_appender/extension_appender'
require_relative 'processors/indexifier_processor'
require_relative 'processors/delete_or_keep_processor'

class RenameRunner

  def initialize
    @audio_extractor = AudioExtractor.new
    @filename_cleaner_processor = FilenameCleanerProcessor.new
    @actresses_processor = ActressesProcessor.new
    @categories_processor = CategoriesProcessor.new
    @rename_processor = RenameProcessor.new
    @tease_processor = Splitter.new("Tease")
    @extension_appender = ExtensionAppender.new
    @indexifier_processor = IndexifierProcessor.new
    @delete_or_keep_processor = DeleteOrKeepProcessor.new
  end

  def run (filename, actresses, categories, tease, audio_extract)
    Console.banner (filename)
    current_name = filename

    processors = get_processors(actresses, categories, tease, audio_extract)

    processors.each do |processor|
      new_name = false
      begin
        new_name = processor.process(current_name, filename)
      rescue ProcessorException => e
        if e.reason == "delete"
          File.delete filename
          puts "Deleted #{filename}"
        elsif e.reason == "skip"
          puts "Skipping #{filename}"          
          return
        elsif e.reason == "next"
          puts "Skipping current processor"
        end
      end

      if new_name
        current_name = new_name
      end
    end
  end

  private

  def get_processors (actresses, categories, tease, audio_extractor)
    processors = []
    processors << @audio_extractor if audio_extractor
    processors << @filename_cleaner_processor if actresses or categories
    processors << @actresses_processor if actresses
    processors << @categories_processor if categories
    processors << @extension_appender if actresses or categories
    processors << @indexifier_processor if actresses or categories
    processors << @rename_processor if actresses or categories
    processors << @tease_processor if tease
    processors << @delete_or_keep_processor

    processors
  end




end