# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dpd_shipping/version'

Gem::Specification.new do |gem|
  gem.name          = "dpd_shipping"
  gem.version       = Dpd::Shipping::VERSION
  gem.authors       = ["Maximilian Richt"]
  gem.email         = ["maxi@richt.name"]
  gem.description   = %q{A simple way to access the dpd/iloxx shipping API}
  gem.summary       = %q{A wrapper around the SOAP-based dpd/iloxx shipping web service. Generate a shipping request and get a label back. Formerly known as iloxx_shipping.}
  gem.homepage      = "https://github.com/robbi5/dpd_shipping"
  gem.license       = 'MIT'

  gem.add_dependency "savon", "~> 2.2.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "webmock", "~> 1.13.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
