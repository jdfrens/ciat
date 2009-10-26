module CIAT::Processors::ShellCommand
  def execute(test)
    RakeFileUtils.verbose(false) do
      sh "#{executable} '#{input_file(test)}' #{command_line_args(test)} > '#{output_file(test)}' 2> '#{error_file(test)}'" do |ok, result|
        return ok
      end
    end
  end
end
