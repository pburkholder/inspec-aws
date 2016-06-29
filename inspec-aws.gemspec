# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inspec/aws/version'

Gem::Specification.new do |spec|
  spec.name          = "inspec-aws"
  spec.version       = Inspec::Aws::VERSION
  spec.authors       = ["Kevin Formsma"]
  spec.email         = ["kevin.formsma@gmail.com"]

  spec.summary       = %q{Extend Inspec with tests against the AWS platform}
  spec.homepage      = "https://github.com/arothian/inspec-aws"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "aws-sdk"
  spec.add_runtime_dependency "inspec"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
