lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'benchin/version'

Gem::Specification.new do |spec|
  spec.name          = 'benchin'
  spec.version       = Benchin::VERSION
  spec.authors       = ['Roman Kolesnev']
  spec.email         = ['rvkolesnev@gmail.com']

  spec.summary       = 'Benchmarking toolset for performance investigations.'
  spec.homepage      = 'https://github.com/ffloyd/benchin'
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ffloyd/benchin'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rainbow', '~> 3.0'
  spec.add_dependency 'stackprof', '~> 0.2'

  # Essential dev deps
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'

  # Testing
  spec.add_development_dependency 'rspec', '~> 3.0'

  # Test Coverage
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'simplecov'

  # Documentation
  spec.add_development_dependency 'yard'

  # Code & Documentation Quality
  spec.add_development_dependency 'forspell', '~> 0.0.8'
  spec.add_development_dependency 'inch'
  spec.add_development_dependency 'mdl'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-md'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
end
