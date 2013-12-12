lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bard/staging_banner/version'

Gem::Specification.new do |gem|
  gem.name          = "bard-staging_banner"
  gem.version       = Bard::StagingBanner::VERSION
  gem.authors       = ["Micah Geisel"]
  gem.email         = ["micah@botandrose.com"]
  gem.description   = %q{Middleware to inject an annoying banner on every page in the staging environment}
  gem.summary       = %q{Middleware to inject an annoying banner on every page in the staging environment}
  gem.homepage      = "https://github.com/botandrose/bard-staging_banner"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

