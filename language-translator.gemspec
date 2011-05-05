# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{language-translator}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Anil Yanduri"]
  s.date = %q{2011-05-05}
  s.description = %q{Ruby gem to translate from one language to another using google api. }
  s.email = %q{anilkumaryln@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/translator.rb"]
  s.files = ["MIT-LICENSE", "Manifest", "README.rdoc", "Rakefile", "language-translator.gemspec", "lib/translator.rb", "test/test_helper.rb", "test/translator_test.rb"]
  s.homepage = %q{http://github.com/anilyanduri/language-translator}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Language-translator", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{language-translator}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Ruby gem to translate from one language to another using google api.}
  s.test_files = ["test/translator_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

