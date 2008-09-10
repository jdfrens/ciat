module CIAT
  module Differs
    # A differ that produces HTML output.
    class HtmlDiffer
      def diff(expected, generated, diff)
        system("diff #{diff_options} '#{expected}' '#{generated}' > '#{diff}'")
      end

      def diff_options
        "--old-group-format='<tr><td class=\"red\"><pre>%<</pre></td><td></td></tr>' " + 
        "--new-group-format='<tr><td></td><td class=\"red\"><pre>%></pre><td></tr>' " +
        "--changed-group-format='<tr class=\"yellow\"><td><pre>%<</pre></td><td><pre>%></pre></td></tr>' " +
        "--unchanged-group-format='<tr class=\"green\"><td><pre>%=</pre></td><td><pre>%=</pre></td></tr>'"
      end
    end
  end
end
