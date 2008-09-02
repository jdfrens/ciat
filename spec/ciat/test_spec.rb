require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @compiler = mock("compiler")
    @executor = mock("executor")
    @compilation_light = mock("compilation traffic light")
    @execution_light = mock("output traffic light")
    @elements = mock("elements")
    @test = CIAT::Test.new(@crate,
      :processors => [@compiler, @executor],
      :compilation_light => @compilation_light, :execution_light => @execution_light)
  end

  describe "running a test" do
    it "should run a complete test" do
      @test.should_receive(:split_test_file)
      @test.should_receive(:write_output_files)
      @test.should_receive(:compile)
      @test.should_receive(:check).with(:compilation, @compilation_light)
      @compilation_light.should_receive(:green?).and_return(true)
      @test.should_receive(:execute)
      @test.should_receive(:check).with(:output, @execution_light)
      @test.should_receive(:report_lights)
      
      @test.run.should == @test
    end

    it "should run a test up to red compilation" do
      @test.should_receive(:split_test_file)
      @test.should_receive(:write_output_files)
      @test.should_receive(:compile)
      @test.should_receive(:check).with(:compilation, @compilation_light)
      @compilation_light.should_receive(:green?).and_return(false)
      @test.should_receive(:report_lights)

      @test.run.should == @test
    end
  end

  describe "splitting a test file" do
    before(:each) do
      filename = mock("filename")
      @crate.should_receive(:test_file).and_return(filename)
      File.should_receive(:read).with(filename).and_return(
        "d\n==== source\ns\n==== target\np\n==== execution\no\n"
        )
    end
    
    it "should split the test file" do
      @test.split_test_file.should == { :description => "d\n",
        :source => "s\n", :compilation_expected => "p\n", :output_expected => "o\n" }
    end
    
    it "should set elements" do
      @test.split_test_file
      @test.elements.should == { :description => "d\n",
        :source => "s\n", :compilation_expected => "p\n", :output_expected => "o\n" }
    end
  end
  
  describe "reading diff information" do
    it "should read compiled diff" do
      filename, contents = mock("compilation diff filename"), mock("contents")
      @crate.should_receive(:compilation_diff).and_return(filename)
      @crate.should_receive(:read_file).with(filename).and_return(contents)
      
      @test.compilation_diff.should == contents
    end
    
    it "should read output diff" do
      filename, contents = mock("output diff filename"), mock("contents")
      @crate.should_receive(:output_diff).and_return(filename)
      @crate.should_receive(:read_file).with(filename).and_return(contents)
      
      @test.output_diff.should == contents
    end
  end
  
  describe "writing output files" do
    it "should write three files" do
      mock_and_expect_filename_and_contents(:source)
      mock_and_expect_filename_and_contents(:compilation_expected)
      mock_and_expect_filename_and_contents(:output_expected)
      
      @test.write_output_files
    end

    it "should write two files when compilation fails" do
      mock_and_expect_filename_and_contents(:source)
      mock_and_expect_filename_and_contents(:compilation_expected)
      mock_and_expect_filename_and_NO_contents(:output_expected)
      
      @test.write_output_files
    end
  end
  
  describe "compiling" do
    it "should compile successfully" do
      source_filename, compilation_generated_filename =
        mock_and_expect_filenames(:source, :compilation_generated)
      @compiler.
        should_receive(:process).
        with(source_filename, compilation_generated_filename).
        and_return(true)
      
      @test.compile
    end

    it "should compile for a yellow light with a error" do
      source_filename, compilation_generated_filename =
        mock_and_expect_filenames(:source, :compilation_generated)
      @compiler.
        should_receive(:process).
        with(source_filename, compilation_generated_filename).
        and_return(false)
      @compilation_light.should_receive(:yellow!)
      
      @test.compile
    end
  end
  
  describe "executing target code" do
    it "should execute successfully" do
      compilation_generated_filename, output_generated_filename =
        mock_and_expect_filenames(:compilation_generated, :output_generated)
      @executor.should_receive(:process).with(compilation_generated_filename, output_generated_filename).and_return(true)
      
      @test.execute
    end
    
    it "should execute for a yellow light with an error" do
      compilation_generated_filename, output_generated_filename =
        mock_and_expect_filenames(:compilation_generated, :output_generated)
      @executor.should_receive(:process).with(compilation_generated_filename, output_generated_filename).and_return(false)
      @execution_light.should_receive(:yellow!)
      
      @test.execute
    end
  end
  
  describe "doing a diff" do
    before(:each) do
      @expected, @generated, @diff = mock("expected"), mock("generated"), mock("diff")
      @filenames = { :expected => @expected, :generated => @generated, :diff => @diff}
      @which = :output
      @filenames.keys.each do |type|
        @crate.should_receive(:output_filename).
          with(@which, type).and_return(@filenames[type])
      end
      @traffic_light = mock("traffic light")
      @result = mock("result")
    end
    
    it "should be green for no difference" do
      @test.should_receive(:diff).with(@expected, @generated, @diff).and_return(true)
      @traffic_light.should_receive(:green!).and_return(@result)
      
      @test.check(@which, @traffic_light).should == @result
    end

    it "should be red for some difference" do
      @test.should_receive(:diff).with(@expected, @generated, @diff).and_return(false)
      @traffic_light.should_receive(:red!).and_return(@result)
      
      @test.check(@which, @traffic_light).should == @result
    end
  end
  
  describe "reporting lights" do
    it "should report both lights to feedback" do
      setting1, setting2 = mock("setting 1"), mock("setting 2")
      @compilation_light.should_receive(:setting).and_return(setting1)
      @feedback.should_receive(:compilation).with(setting1)
      @execution_light.should_receive(:setting).and_return(setting2)
      @feedback.should_receive(:execution).with(setting2)
      
      @test.report_lights
    end
  end

  #
  # Helpers
  #
  def mock_and_expect_filename_and_contents(type)
    filename = mock_and_expect_filename(type)
    contents = mock(type.to_s + " contents")
    @test.should_receive(:elements).any_number_of_times.and_return(@elements)
    @elements.should_receive(:[]).with(type).at_least(:once).and_return(contents)
    @crate.should_receive(:write_file).with(filename, contents)
  end

  def mock_and_expect_filename_and_NO_contents(type)
    @test.should_receive(:elements).any_number_of_times.and_return(@elements)
    @elements.should_receive(:[]).with(type).at_least(:once).and_return("   NONE\n\n")
  end

  def mock_and_expect_filenames(*types)
    types.map { |type| mock_and_expect_filename(type) }
  end
  
  def mock_and_expect_filename(type)
    filename = mock(type.to_s + " filename")
    @crate.should_receive(type).and_return(filename)
    filename
  end
end
