require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @crate = mock("crate")
    @compiler = mock("compiler")
    @executor = mock("executor")
    @traffic_lights = { :compilation => mock("compilation traffic light"), :output => mock("output traffic light") }
    @test = CIAT::Test.new(@crate, @compiler, @executor, :traffic_lights => @traffic_lights)
  end

  describe "running a test" do
    it "should run a complete test" do
      @test.should_receive(:split_test_file)
      @test.should_receive(:write_output_files)
      @test.should_receive(:compile)
      @test.should_receive(:execute)
      @test.should_receive(:check_output)
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

    it "should compile with a failure" do
      source_filename, compilation_generated_filename =
        mock_and_expect_filenames(:source, :compilation_generated)
      @compiler.
        should_receive(:compile).
        with(source_filename, compilation_generated_filename).
        and_return(false)
      @traffic_lights[:compilation].
        should_receive(:yellow!)
      
      @test.compile
    end
  end
  
  describe "running program" do
    it "should run program when compilation was successful" do
      compilation_generated_filename, output_generated_filename =
        mock_and_expect_filenames(:compilation_generated, :output_generated)
      @traffic_lights[:compilation].should_receive(:yellow?).and_return(false)
      @executor.should_receive(:execute).with(compilation_generated_filename, output_generated_filename)
      
      @test.execute
    end

    it "should run program" do
      @traffic_lights[:compilation].should_receive(:yellow?).and_return(true)
      
      @test.execute
    end
  end
  
  describe "checking output" do
    it "should check all output when everything runs fine" do
      compilation_expected_filename, compilation_generated_filename, compilation_diff_filename =
        mock_and_expect_filenames(:compilation_expected, :compilation_generated, :compilation_diff)
      output_expected_filename, output_generated_filename, output_diff_filename =
        mock_and_expect_filenames(:output_expected, :output_generated, :output_diff)
      @test.should_receive(:do_diff).with(:compilation, compilation_expected_filename, compilation_generated_filename, compilation_diff_filename)
      @traffic_lights[:compilation].should_receive(:yellow?).and_return(false)
      @test.should_receive(:do_diff).with(:output, output_expected_filename, output_generated_filename, output_diff_filename)
      
      @test.check_output
    end

    it "should check output of just compiler when compiler fails" do
      compilation_expected_filename, compilation_generated_filename, compilation_diff_filename =
        mock_and_expect_filenames(:compilation_expected, :compilation_generated, :compilation_diff)
      @test.should_receive(:do_diff).with(:compilation, compilation_expected_filename, compilation_generated_filename, compilation_diff_filename)
      @traffic_lights[:compilation].should_receive(:yellow?).and_return(true)

      @test.check_output
    end
  end
  
  describe "doing a diff" do
    before(:each) do
      @expected, @generated, @diff = mock("expected"), mock("generated"), mock("diff")
    end
    
    it "should be green for no difference" do
      result = mock("result")
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(true)
      @traffic_lights[:compilation].should_receive(:green!).and_return(result)
      
      @test.do_diff(:compilation, @expected, @generated, @diff).should == result
    end

    it "should be red for some difference" do
      result = mock("result")
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(false)
      @traffic_lights[:output].should_receive(:red!).and_return(result)
      
      @test.do_diff(:output, @expected, @generated, @diff).should == result
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
