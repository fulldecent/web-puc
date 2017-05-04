require './lib/version'

Gem::Specification.new { |s|
  s.name = 'web-puc'
  s.summary = 'Web Package Update Checker'
  s.description = 'Validate your web project uses the latest CSS & JS includes'
  s.license = 'MIT'
  s.version = WebPuc::VERSION
  s.authors = ['William Entriken']
  s.email = 'github.com@phor.net'
  s.executables << 'web-puc'
  s.files       = Dir['lib/*', 'lib/package-spiders/*.sh', 'lib/packages/*']
  s.homepage    = 'https://github.com/fulldecent/web-puc'

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'structured-acceptance-test', '~> 0.0.6'
  s.add_development_dependency 'rspec'
}
