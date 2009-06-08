# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hive}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2009-06-08}
  s.email = %q{dan@zeraweb.com}
  s.files = ["lib/hive/scheduler.rb", "lib/hive/worker.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dyoder/hive}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Open-source Ruby framework for background processing.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<facets>, [">= 1.0"])
    else
      s.add_dependency(%q<facets>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<facets>, [">= 1.0"])
  end
end
