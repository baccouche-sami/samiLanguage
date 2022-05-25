# -*- encoding: utf-8 -*-
# stub: standard 1.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "standard".freeze
  s.version = "1.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Justin Searls".freeze]
  s.bindir = "exe".freeze
  s.date = "2022-04-11"
  s.email = ["searls@gmail.com".freeze]
  s.executables = ["standardrb".freeze]
  s.files = ["exe/standardrb".freeze]
  s.homepage = "https://github.com/testdouble/standard".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "Ruby Style Guide, with linter & automatic code fixer".freeze

  s.installed_by_version = "3.0.3.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubocop>.freeze, ["= 1.27.0"])
      s.add_runtime_dependency(%q<rubocop-performance>.freeze, ["= 1.13.3"])
    else
      s.add_dependency(%q<rubocop>.freeze, ["= 1.27.0"])
      s.add_dependency(%q<rubocop-performance>.freeze, ["= 1.13.3"])
    end
  else
    s.add_dependency(%q<rubocop>.freeze, ["= 1.27.0"])
    s.add_dependency(%q<rubocop-performance>.freeze, ["= 1.13.3"])
  end
end
