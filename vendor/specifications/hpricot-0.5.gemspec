Gem::Specification.new do |s|
  s.name = %q{hpricot}
  s.version = "0.5"
  s.date = %q{2007-01-31}
  s.summary = %q{a swift, liberal HTML parser with a fantastic library}
  s.email = %q{why@ruby-lang.org}
  s.homepage = %q{http://code.whytheluckystiff.net/hpricot/}
  s.description = %q{a swift, liberal HTML parser with a fantastic library}
  s.has_rdoc = true
  s.authors = ["why the lucky stiff"]
  s.files = ["COPYING", "README", "Rakefile", "test/files", "test/test_preserved.rb", "test/test_paths.rb", "test/load_files.rb", "test/test_xml.rb", "test/test_parser.rb", "test/files/boingboing.html", "test/files/uswebgen.html", "test/files/immob.html", "test/files/week9.html", "test/files/utf8.html", "test/files/basic.xhtml", "test/files/cy0.html", "lib/hpricot", "lib/hpricot_scan.so", "lib/hpricot.rb", "lib/hpricot/htmlinfo.rb", "lib/hpricot/text.rb", "lib/hpricot/inspect.rb", "lib/hpricot/modules.rb", "lib/hpricot/parse.rb", "lib/hpricot/tag.rb", "lib/hpricot/traverse.rb", "lib/hpricot/elements.rb", "extras/mingw-rbconfig.rb", "ext/hpricot_scan/hpricot_scan.h", "ext/hpricot_scan/hpricot_scan.c", "ext/hpricot_scan/extconf.rb", "ext/hpricot_scan/hpricot_scan.rl", "CHANGELOG"]
  s.rdoc_options = ["--quiet", "--title", "The Hpricot Reference", "--main", "README", "--inline-source"]
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.extensions = ["ext/hpricot_scan/extconf.rb"]
end
