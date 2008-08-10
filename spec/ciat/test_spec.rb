require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @compiler = mock("compiler")
    @executor = mock("executor")
    @compilation_light = mock("compilation traffic light")
    @execution_light = mock("output traffic light")
    @test = CIAT::Test.new(@crate, @compiler, @executor,
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
      @test.run.should == @test
    end

    it "should run a test up to red compilation" do
      @test.should_receive(:split_test_file)
      @test.should_receive(:write_output_files)
      @test.should_receive(:compile)
      @test.should_receive(:check).with(:compilation, @compilation_light)
      @compilation_light.should_receive(:green?).and_return(false)
      @test.run.should == @test
    end
  end

  describe "splitting a test file" do
    it "should split the test file" do
      filename = mock("filename")
      @crate.should_receive(:test_file).and_return(filename)
      File.should_receive(:read).with(filename).and_return("d\n====\ns\n====\np\n====\no\n====\n")
      
      @test.split_test_file.should == ["d\n", "s\n", "p\n", "o\n"]
    end
  end
  
  describe "writing output files" do
    it "should write three files" do
      mock_and_expect_filename_and_contents(:source)
      mock_and_expect_filename_and_contents(:compilation_expected)
      mock_and_expect_filename_and_contents(:output_expected)
      
      @test.write_output_files
    end

    it "should write two files when compilation is supposed to fail" do
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
        should_receive(:compile).
        with(source_filename, compilation_generated_filename).
        and_return(true)
      
      @test.compile
    end

    it "should compile for a yellow light with a error" do
      source_filename, compilation_generated_filename =
        mock_and_expect_filenames(:source, :compilation_generated)
      @compiler.
        should_receive(:compile).
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
      @executor.should_receive(:execute).with(compilation_generated_filename, output_generated_filename).and_return(true)
      
      @test.execute
    end
    
    it "should execute for a yellow light with an error" do
      compilation_generated_filename, output_generated_filename =
        mock_and_expect_filenames(:compilation_generated, :output_generated)
      @executor.should_receive(:execute).with(compilation_generated_filename, output_generated_filename).and_return(false)
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
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(true)
      @traffic_light.should_receive(:green!).and_return(@result)
      
      @test.check(@which, @traffic_light).should == @result
    end

    it "should be red for some difference" do
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(false)
      @traffic_light.should_receive(:red!).and_return(@result)
      
      @test.check(@which, @traffic_light).should == @result
    end
  end

  #
  # Helpers
  #
  def mock_and_expect_filename_and_contents(type)
    filename = mock_and_expect_filename(type)
    contents = mock(type.to_s + " contents")
    @test.should_receive(type).at_least(:once).and_return(contents)
    @crate.should_receive(:write_file).with(filename, contents)
  end

  def mock_and_expect_filename_and_NO_contents(type)
    @test.should_receive(type).at_least(:once).and_return("   NONE\n\n")
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
