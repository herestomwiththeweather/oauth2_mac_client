# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oauth2_mac_client/version"

Gem::Specification.new do |s|
  s.name        = "oauth2_mac_client"
  s.version     = Oauth2MacClient::VERSION
  s.authors     = ["Tom Brown"]
  s.email       = ["herestomwiththeweather@gmail.com"]
  s.homepage    = "https://github.com/herestomwiththeweather/oauth2_mac_client"
  s.summary     = %q{Send requests to OAuth 2 provider with MAC authentication}
  s.description = %q{Send requests to OAuth 2 provider with MAC authentication}

  s.rubyforge_project = "oauth2_mac_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
