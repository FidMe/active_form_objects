Gem::Specification.new do |s|
  s.name        = 'active_form_objects'
  s.version     = '2.1.2'
  s.date        = '2019-10-30'
  s.summary     = 'A step toward an hexagonal Rails architecture'
  s.description = 'Clean up your controller, slim up your models, handle more use cases'
  s.authors     = ['Michaël Villeneuve']
  s.homepage    = 'https://github.com/fidme/active_form_objects'
  s.email       = 'contact@michaelvilleneuve.fr'
  s.files       = Dir['lib/**/*']
  s.license     = 'MIT'
  s.add_runtime_dependency(%q<activesupport>, ['>= 4.2'])
  s.add_runtime_dependency(%q<activerecord>, ['>= 4.2'])
  s.add_runtime_dependency(%q<activemodel>, ['>= 4.2'])
  s.add_runtime_dependency('method_source', ['~> 0.9.2'])
  s.add_runtime_dependency(%q<ruby_parser>, ["~> 3.1"])
  s.add_runtime_dependency(%q<ruby2ruby>, ["> 2.4.0"])
end
