Gem::Specification.new do |s|
  s.name        = 'active_form_objects'
  s.version     = '0.1.0'
  s.date        = '2018-11-20'
  s.summary     = 'A step toward an hexagonal Rails architecture'
  s.description = 'Clean up your controller, slim up your models, handle more use cases'
  s.authors     = ['Michaël Villeneuve']
  s.homepage    = 'https://github.com/fidme/active_form_objects'
  s.email       = 'contact@michaelvilleneuve.fr'
  s.files       = ['lib/active_form_objects.rb']
  s.license     = 'MIT'
  s.add_runtime_dependency(%q<activesupport>, ['>= 4.2'])
  s.add_runtime_dependency(%q<activemodel>, ['>= 4.2'])
end
