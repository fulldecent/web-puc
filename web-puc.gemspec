Gem::Specification.new { |s|
  s.name        = "web-puc"
  s.version     = "0.4.1"
  s.summary     = "Web Package Update Checker"
  s.description = "Validate your web project uses the latest CSS & JS includes"
  s.authors     = ["William Entriken"]
  s.email       = "github.com@phor.net"
  s.files       = ["lib/web-puc.rb"]
  s.homepage    = "https://github.com/fulldecent/web-puc"
  s.license     = "MIT"
  s.executables << "web-puc"

  s.add_runtime_dependency 'rake', '>= 12'
  s.add_runtime_dependency 'http', '~> 5.1'
}
