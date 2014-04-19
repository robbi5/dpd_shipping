# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iloxx_shipping/version'

Gem::Specification.new do |gem|
  gem.name          = "iloxx_shipping"
  gem.version       = Iloxx::Shipping::VERSION
  gem.authors       = ["Maximilian Richt"]
  gem.email         = ["maxi@richt.name"]
  gem.description   = %q{(DEPRECATED, see dpd_shipping) A simple way to access the iloxx shipping API}
  gem.summary       = %q{(DEPRECATED, see dpd_shipping) A wrapper around the SOAP-based iloxx shipping web service. Generate a shipping request and get a label back.}
  gem.homepage      = "https://github.com/robbi5/iloxx_shipping"
  gem.license       = 'MIT'

  gem.post_install_message = <<-MESSAGE
 !    The 'iloxx_shipping' gem has been deprecated and replaced by 'dpd_shipping'.
 !    See: https://rubygems.org/gems/dpd_shipping
 !    And: https://github.com/robbi5/dpd_shipping
  MESSAGE

  gem.add_dependency "savon", "~> 2.2.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "webmock", "~> 1.13.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
