# = A Rake Task for a Suite of Tests
#
# This is the class to use in your +Rakefile+.  The simplest use looks like
# this:
#
#   CIAT::RakeTask(:name_of_task) do |t|
#     t.processors << compiler
#     t.processors << executor
#   end
#
# Define +compiler+ and +executor+ in the +Rakefile+ to return a compiler and
# executor, respectively.  <code>:name_of_task</code> is (as I try to make
# clear by its name) the name of the rake task.  If you leave out this name,
# it defaults to <code>:ciat</code>.  The options on +t+ correspond directly
# to the options of CIAT::Suite.  See CIAT::Suite for defaults and details.
#
# * <code>t.processors</code> is <em>required</em> and specifies the
#   processors to be executed; order matters!  Use <code>=</code> to assign a
#   list of processors; use <code>&lt;&lt;</code> to push processors onto the
#   existing list of processors.
# * <code>t.folder</code> specifies folders to search for test files.
# * <code>t.files</code> is an array of specific files.
# * <code>t.report_filename</code> is the name of the report
# * <code>t.feedback</code> specifies a feedback mechanism
#
class CIAT::RakeTask
  attr_accessor :processors
  attr_accessor :files
  attr_accessor :feedback
  attr_accessor :folder
  attr_accessor :report_filename
  attr_accessor :report_title
  attr_accessor :output_folder
  
  def initialize(name = :ciat)
    @name = name
    @processors = []
    yield self if block_given?
    define
  end
  
  def define
    desc "Run CIAT tests" + (@name==:test ? "" : ", #{@name}")
    task @name do
      suite = CIAT::Suite.new(
        :processors => @processors,
        :files => @files,
        :feedback => @feedback,
        :folder => @folder,
        :report_filename => @report_filename,
        :output_folder => @output_folder,
        :report_title => @report_title)
      suite.run
    end
  end
end