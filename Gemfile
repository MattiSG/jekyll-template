require 'json'
require 'net/http'

source 'https://rubygems.org'

begin
  versions_url = URI('https://pages.github.com/versions.json')
  versions     = JSON.parse(Net::HTTP.get(versions_url))

  # Make sure we build locally with the same version than Github Pages does.
  gem 'github-pages', versions['github-pages'], group: :jekyll_plugins

  # Prevent CircleCI to push to Github if the Ruby version is not the GitHub Pages one.
  # See <https://circleci.com/docs/unrecognized-ruby-version/>
  ruby versions['ruby'] if ENV['CI']

# If the GitHub Pages versions endpoint is unreacheable, we assume offline development.
rescue SocketError => socket_error
  # If in CI, this means we can't validate version match, and there is no reason to be offline. Abort.
  raise socket_error if ENV['CI']

  puts <<-MESSAGE
    Couldn't reach #{versions_url.to_s}, assuming you're offline.
  MESSAGE

  # Use whichever version is already installed without checking production version match.
  gem 'github-pages'

# If for any other reason the production versions check fails, we still provide a fallback scenario.
rescue => standard_error
  # If in CI, this means we can't validate version match. Abort.
  raise standard_error if ENV['CI']

  puts <<-MESSAGE
    Something went wrong trying to parse production versions.
      Exception name:    #{standard_error.class.name}
      Exception message: #{standard_error.message}
  MESSAGE

  # Try to use whatever version is already installed.
  gem 'github-pages'
end

group :test do
  gem 'html-proofer'
end
