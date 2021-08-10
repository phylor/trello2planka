require_relative 'lib/trello2planka/version'

Gem::Specification.new do |spec|
  spec.name          = "trello2planka"
  spec.version       = Trello2planka::VERSION
  spec.authors       = ["Serge Hänni"]
  spec.email         = ["serge@nyi.ch"]

  spec.summary       = %q{Copy Trello boards to Planka}
  spec.homepage      = "https://github.com/phylor/trello2planka"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/phylor/trello2planka"
  spec.metadata["changelog_uri"] = "https://github.com/phylor/trello2planka/raw/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'ruby-trello'
end
