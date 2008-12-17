module CIAT
  module Differs
    # Module for implementing the diff between two files.
    # The output is in HTML table rows with the expected output on the left and
    # the generated on the right.
    module HtmlDiffer
      def html_diff(expected_file, generated_file, diff_file)
        system("diff #{diff_options} '#{expected_file}' '#{generated_file}' > '#{diff_file}'")
      end

      # TODO: it would be nice to have line numbers in the output
      def diff_options
        "--old-group-format='<tr><td class=\"red\"><pre>%<</pre></td><td></td></tr>' " + 
        "--new-group-format='<tr><td></td><td class=\"red\"><pre>%></pre><td></tr>' " +
        "--changed-group-format='<tr class=\"yellow\"><td><pre>%<</pre></td><td><pre>%></pre></td></tr>' " +
        "--unchanged-group-format='<tr class=\"green\"><td><pre>%=</pre></td><td><pre>%=</pre></td></tr>'"
      end
    end
  end
end
