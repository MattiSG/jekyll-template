require 'json'
require 'net/http'

source 'https://rubygems.org'


begin
  versions_url = 'https://pages.github.com/versions.json'
  versions     = JSON.parse(Net::HTTP.get(URI(versions_url)))

  # Ensure matching of the local gems with the production version of Github Pages.
  gem 'github-pages', versions['github-pages'], group: :jekyll_plugins

  ruby versions['ruby'] if ENV['CI']
  # Ensure matching of the local Ruby version with the production version of GitHub Pages.

# If the GitHub Pages versions endpoint is unreacheable, assume offline development.
rescue SocketError => socket_error
  # If in CI, this means we can't validate version match, and there is no reason to be offline. Abort.
  raise socket_error if ENV['CI']

  puts "Couldn't reach #{versions_url}, assuming you're offline."

  # Use whichever version is already installed without checking production version match.
  gem 'github-pages'

# Provide a fallback scenario if for any other reason the production versions check fails.
rescue => standard_error
  # If in CI, this means we can't validate version match. Abort.
  raise standard_error if ENV['CI']

  puts <<-MESSAGE
    Something went wrong trying to parse production versions: #{standard_error.class.name}
    ---
    #{standard_error.message}
    ---
  MESSAGE

  # Use whichever version is already installed without checking production version match.
  gem 'github-pages'
end

group :test do
  gem 'html-proofer'
end
