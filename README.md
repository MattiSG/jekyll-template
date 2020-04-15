# Jekyll template

Jekyll is a static website generator. It is flexible and easy to use, and one of its best benefits is that you can use CD tools provided by code hosting platforms such as GitHub Pages or GitLab Pages to make the built website available on the internet, at no cost.


## Install Ruby with `rbenv`

We'll use `rbenv` to make sure that the Ruby version is the same across all environments.

### Install rbenv

For that, we'll start by [installing rbenv](https://github.com/rbenv/rbenv#installation). Make sure you read all the instructions and go through the `rbenv init` stage, otherwise it will not work!

> The alternative to rbenv is RVM. If you have it already installed on your system, or you prefer to use it for any reason, there is no need to switch to rbenv.

### Specify the Ruby version

Since we want to make sure that we use the same version of all dependencies and runtimes across all environments, and the only one we can't control is the one chosen by GitHub, we'll align all environments with that one. Thus, we'll get the Ruby version we want to use from their published [versions file](https://pages.github.com/versions.json).

The [`.ruby-version` file](https://github.com/rbenv/rbenv#choosing-the-ruby-version) should contain the… version of Ruby we want to use. In our case, that version is given in the `ruby` key of GitHub’s [versions file](https://pages.github.com/versions.json).

## Install Jekyll

We could install Jekyll with `gem`. However, we wouldn't know if later on GitHub updates their versions, and that could yield a conflict later on.

```
gem install bundler --no-ri --no-rdoc
bundle install
```

We can then test that everything went well with:

```
bundle exec jekyll doctor
```

## Set up your website

Edit the `_config.yml` to set some description elements.

```
bundle exec jekyll serve --incremental
```

## Publish to GitHub Pages

- Create a repository on GitHub.
- Push your content to it.
- Activate GitHub Pages in the settings.


## Set up Continuous Integration

We'll use [CircleCI](https://circleci.com). They offer a free plan for open-source.
Just log in with GitHub and activate builds for your repository.

