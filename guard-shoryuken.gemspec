# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/shoryuken/version"

Gem::Specification.new do |s|
  s.name        = "guard-shoryuken"
  s.version     = Guard::ShoryukenVersion::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Bolusmjak", "pitr", "Eduardo Sebastian"]
  s.email       = ["code@tagloo.com"]
  s.homepage    = 'http://github.com/tagloo/guard-shoryuken'
  s.summary     = %q{guard gem for shoryuken}
  s.description = %q{Guard::Shoryuken automatically starts/stops/restarts Shoryuken workers}

  s.add_dependency 'guard', '>= 2'
  s.add_dependency('guard-compat', '~> 1.0')
  s.add_dependency 'shoryuken'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',         '~> 2.5.0'
  s.add_development_dependency 'guard-rspec',   '>= 0.2.0'
  s.add_development_dependency 'guard-bundler', '>= 0.1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
