# -*- encoding: utf-8 -*-
require File.expand_path('../lib/defile/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gary Rennie"]
  gem.email         = ["webmaster@gazler.com"]
  gem.description   = %q{The easy way to manage dotfiles}
  gem.summary       = %q{The easy way to manage dotfiles}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "defile"
  gem.require_paths = ["lib"]
  gem.version       = Defile::VERSION

  gem.add_development_dependency "rspec", "~>2.8.0"
  gem.add_dependency "thor", "~>0.14.6"
  gem.add_dependency "rake"
end
