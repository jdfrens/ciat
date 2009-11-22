Dir["*.latte"].each do |latte_file|
  html_file = latte_file.gsub(/\.latte$/, ".html")
  file html_file => latte_file do |t|
    sh "nolatte #{t.name.gsub(/\.html$/, ".latte")} > #{t.name}"
  end
end

task :default => Dir["*.latte"].map { |f| f.gsub(/\.latte$/, ".html")}
