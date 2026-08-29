Gem::Specification.new do |spec|
  spec.name          = "rails_db_dump"
  spec.version       = RailsDbDump::VERSION
  spec.authors       = ["hulous"]
  spec.email         = ["fhulous@gmail.com"]

  spec.summary       = "A basic Rails gem skeleton for database dump utilities."
  spec.description   = "A lightweight Rails engine gem providing a starting point for database dump and Rails extension functionality."
  spec.homepage      = "https://github.com/hulous/rails_db_dump"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com'
  spec.metadata['source_code_uri'] = 'https://github.com/hulous/rails_db_dump'

  spec.files         = Dir.glob("**/*").reject { |f| f.start_with?(".git/") || f =~ %r{\A(?:tmp|log|vendor)/} }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rspec", ">= 3.0"
end
