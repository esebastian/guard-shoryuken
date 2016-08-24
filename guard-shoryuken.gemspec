# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/shoryuken/version"

Gem::Specification.new do |s|
  s.name        = "guard-shoryuken"
  s.version     = Guard::ShoryukenVersion::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eduardo Sebastian"]
  s.email       = ["esebastian@altiora.es"]
  s.homepage    = 'http://github.com/esebastian/guard-shoryuken'
  s.summary     = %q{guard gem for shoryuken}
  s.description = %q{Guard::Shoryuken automatically starts/stops/restarts Shoryuken workers}
  s.license     = 'Apache-2.0'

  s.add_dependency 'guard', '2.12.5'
  s.add_dependency 'guard-compat', '~> 1.0'
  s.add_dependency 'shoryuken', '~> 1'

  s.add_development_dependency 'bundler',       '~> 1'
  s.add_development_dependency 'rb-fsevent',    '~> 0'
  s.add_development_dependency 'rake',          '~> 10'
  s.add_development_dependency 'rspec',         '2.5.0'
  s.add_development_dependency 'guard-rspec',   '~> 1.2'
  s.add_development_dependency 'guard-bundler', '~> 2.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
