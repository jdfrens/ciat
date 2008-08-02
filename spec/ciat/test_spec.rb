require File.dirname(__FILE__) + '/../spec_helper.rb'

describe CIAT::Test do
  before(:each) do
    @namer = mock("namer")
    @compiler = mock("compiler")
    @executor = mock("executor")
    @test = CIAT::Test.new(@namer, @compiler, @executor)
  end

  describe "running a test" do
    it "should description" do
      @test.should_receive(:split_test_file)
      @test.should_receive(:write_output_files)
      @test.should_receive(:compile)
      @test.should_receive(:execute)
      @test.should_receive(:check_output)
      @test.run.should == @test
    end
  end

  describe "showing traffic lights" do
    it "should have individual traffic lights" do
      light = mock("light")
      @test.traffic_lights.should_receive(:[]).with(:foo).and_return(light)
      @test.traffic_light(:foo).should == light
    end
  
    it "should deal with all green lights" do
      lights = [:green, :green, :green]
      @test.traffic_lights.should_receive(:values).and_return(lights)
      @test.traffic_light(:all).should == :green
    end

    it "should deal with no lights" do
      lights = []
      @test.traffic_lights.should_receive(:values).and_return(lights)
      @test.traffic_light(:all).should == :green
    end

    it "should deal with a red light" do
      lights = [:green, :red, :green]
      @test.traffic_lights.should_receive(:values).and_return(lights)
      @test.traffic_light(:all).should == :red
    end
  end

  describe "splitting a test file" do
    it "should split the test file" do
      filename = mock("filename")
      @namer.should_receive(:test_file).and_return(filename)
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
  end
  
  describe "compiling" do
    it "should compile with compiler object" do
      source_filename, compilation_generated_filename =
        mock_and_expect_filenames(:source, :compilation_generated)
      @compiler.should_receive(:compile).with(source_filename, compilation_generated_filename)
      
      @test.compile
    end
  end
  
  describe "running program" do
    it "should run program" do
      compilation_generated_filename, output_generated_filename =
        mock_and_expect_filenames(:compilation_generated, :output_generated)
      @executor.should_receive(:execute).with(compilation_generated_filename, output_generated_filename)
      
      @test.execute
    end
  end
  
  describe "checking output" do
    it "should check output" do
      compilation_expected_filename, compilation_generated_filename, compilation_diff_filename =
        mock_and_expect_filenames(:compilation_expected, :compilation_generated, :compilation_diff)
      output_expected_filename, output_generated_filename, output_diff_filename =
        mock_and_expect_filenames(:output_expected, :output_generated, :output_diff)
      @test.should_receive(:do_diff).with(compilation_expected_filename, compilation_generated_filename, compilation_diff_filename)
      @test.should_receive(:do_diff).with(output_expected_filename, output_generated_filename, output_diff_filename)
      
      @test.check_output
    end
  end
  
  describe "doing a diff" do
    before(:each) do
      @expected, @generated, @diff = mock("expected"), mock("generated"), mock("diff")
    end
    
    it "should be green for no difference" do
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(true)
      
      @test.do_diff(@expected, @generated, @diff).should == :green
    end

    it "should be red for some difference" do
      @test.should_receive(:system).with("diff '#{@expected}' '#{@generated}' > '#{@diff}'").and_return(false)
      
      @test.do_diff(@expected, @generated, @diff).should == :red
    end
  end

  #
  # Helpers
  #
  def mock_and_expect_filename_and_contents(type)
    filename = mock_and_expect_filenames(type)[0]
    contents = mock(type.to_s + " contents")
    @test.should_receive(type).and_return(contents)
    @test.should_receive(:write_file).with(filename, contents)
  end

  def mock_and_expect_filenames(*types)
    types.map do |type|
      filename = mock(type.to_s + " filename")
      @namer.should_receive(type).and_return(filename)
      filename
    end
  end
end
