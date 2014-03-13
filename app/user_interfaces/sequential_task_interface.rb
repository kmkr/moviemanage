require_relative '../common/filename_cleaner'
require_relative '../common/console'
require_relative '../common/processor_exception'
require_relative '../common/processor_exception_handler'

require_relative '../processors/audio_extractor'
require_relative '../processors/filename_cleaner_processor'
require_relative '../processors/actresses/processor'
require_relative '../processors/categories/processor'
require_relative '../processors/rename_processor'
require_relative '../splitter/splitter'
require_relative '../processors/extension_appender'
require_relative '../processors/indexifier_processor'
require_relative '../processors/delete_or_keep_processor'


class SequentialTaskInterface

  def initialize(options)
    @scene_splitter_processor = Splitter.new("Scene")
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

  def run (filename, options)
    Console.banner (filename)
    current_name = filename

    processors = get_processors(options)

    processors.each do |processor|
      new_name = false
      begin
        new_name = processor.process(current_name, filename)
      rescue ProcessorException => e
        ProcessorExceptionHandler.new.handle(e)
      end

      if new_name
        current_name = new_name
      end
    end
  end

  private

  def get_processors (options)
    processors = []
    processors << @scene_splitter_processor if options[:split]
    processors << @audio_extractor if options[:audio_extract]
    processors << @filename_cleaner_processor if options[:actresses] or options[:categories]
    processors << @actresses_processor if options[:actresses]
    processors << @categories_processor if options[:categories]
    processors << @extension_appender if options[:actresses] or options[:categories]
    processors << @indexifier_processor if options[:actresses] or options[:categories]
    processors << @rename_processor if options[:actresses] or options[:categories]
    processors << @tease_processor if options[:tease]
    processors << @delete_or_keep_processor

    processors
  end

end