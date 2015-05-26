# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bloomit/version'

Gem::Specification.new do |spec|
  spec.name          = 'bloomit'
  spec.version       = Bloomit::VERSION
  spec.authors       = ['Aleksei Matiushkin']
  spec.email         = ['aleksei.matiushkin@kantox.com']

  spec.summary       = 'Mixin to colorize everything basing on it’s name/properties.'
  spec.description   = 'Mixin to include/extend. Being used with diagrams output and like.'
  spec.homepage      = 'http://kantox.com'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|features)\//) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = FURY
  end

  spec.add_dependency 'damerau-levenshtein', '~> 1.1'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'

  spec.add_development_dependency 'cucumber', '~> 1.3'
end
