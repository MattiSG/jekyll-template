# Jekyll landing page & website industrial template

## Introduction

### Context

[Jekyll](https://jekyllrb.com/) is a static website generator.

> This means it transforms pieces of content in Markdown or HTML into full HTML files that can be displayed in web browsers.

It is flexible and easy to use. Other static website generators exist. However, one of the main benefits of Jekyll is that it can be run and hosted for free directly by code hosting platforms such as [GitHub](https://pages.github.com) or [GitLab](https://docs.gitlab.com/ee/user/project/pages/) through their Pages feature, and you can always switch to your own server at any time.

> This means your website can be made available on the internet at no cost.

Jekyll claims to be “blog-aware”. It is indeed, supporting notions such as posts, publishing dates and authors out of the box. More than “aware”, though, the default boilerplate and some of the documentation will guide you towards blog posts.

Jekyll can do much more than that and, over the years, I have come to build and reuse a set of practices and presets that support my main use case: building and deploying landing pages cheap and fast (under half a day) that enable non-technical users to contribute content through online text editors, and maintain an ability to scale to an entire website with full quality control.

### Intention

**I aim for the sweet spot where efficient contribution is possible both for developers and non-technical users**.

> The developer experience is indeed most of the time terrible with CMSs that ship WYSIWYG editors, and learning HTML and managing metadata is too much for the vast majority of non-technical users.

This repository aims at making it easier to use Jekyll to:

- **Publish websites** or at least landing pages, not blogs.
- **Get contributions from non-technical users**, purely with online code editors.
- **Build upon convention** rather than configuration.
- **Display page metadata**.

It regroups the setup and best practices I have identified. While reusable as such, it is perhaps better to think of it as a library than as a template.

### Examples

This approach has enabled me to build products such as:

- [beta.gouv.fr](https://beta.gouv.fr), the website of the French government public digital services incubator, which uses Jekyll both as CMS and HR system and has [over 370 contributors](https://github.com/betagouv/beta.gouv.fr/) of all sorts.
- [disinfo.quaidorsay.fr](https://disinfo.quaidorsay.fr), a resource supporting actors countering information manipulation (aka “fake news”), which uses Jekyll for a [multilingual](https://github.com/ambanum/disinfo.quaidorsay.fr/tree/master/_pages), [collaborative encyclopedia](https://github.com/ambanum/disinfo.quaidorsay.fr/tree/master/_pages/en/encyclopedia) of tools and practices.
- [pariscall.international](https://pariscall.international), the public website for the Paris Call for Trust and Security in Cyberspace, which uses Jekyll to maintain a [list of signatories](https://github.com/ambanum/pariscall.international/tree/master/_supporters) and relies on an additional [backend](https://github.com/ambanum/pariscall.international-backend) to [create files](https://github.com/ambanum/pariscall.international/commits?author=AmbNum-Bot) from survey answers, making it easy for anyone to add files and for non-technical maintainers to update the data over time.


## Features

### Production versions synchronisation

It is a standard practice to ensure that your development and production environments are in sync, in order to ensure bugs can be caught before production, or at least reproduced in development. Most of the time, this is achieved by locking down versions in development so that production updates accordingly.

However, when relying on hosting providers such as GitHub Pages, we cannot force production versions and depend on the host update frequency and dependency choices. In this case, the only way to ensure both environments are in sync is to… enforce production versions in dev!

#### Local

This is why the `Gemfile` in this repository is dynamic. It relies on GitHub [exposing their production versions](https://pages.github.com/versions.json) in JSON, and parses them (including the Ruby runtime version) on update. A fallback mechanism supports offline work and assumes local versions are correct —you won’t be pushing work if you’re offline anyway 🙂

The Ruby version itself is locked with the `.ruby-version` file, and `bundler` will complain if it does not match the production version.

_[Credit](https://github.com/betagouv/beta.gouv.fr/commits/master/Gemfile) goes to @MaukoQuiroga for most of the dynamic Gemfile code._

#### CI

Continuous integration means testing on every push. The Jekyll documentation provides a [template for CircleCI](https://jekyllrb.com/docs/continuous-integration/circleci/). That template assumes a deployment to Amazon S3 where you control production versions.

This is why the `.circleci/config.yml` in this repository builds using the same versions and options as GitHub Pages does (in particular, “safe mode” which disables most plugins), and enforces additional checks such as HTML spec compliance.


### Social cards

Most Jekyll themes don’t provide the [meta tags for “social cards”](https://gist.github.com/MattiSG/fc7f65ad16fb8968e0f84b756efd9383) that will enable rich content preview on major social media.

The `_includes/metadata.html` in this repository ships the minimal amount of code to enable rich preview on Facebook, Twitter, LinkedIn and any other [OpenGraph](https://ogp.me)-compatible scraper.


### Advanced features discoverability

Some of the lesser-known yet very powerful features of Jekyll are [collections](https://jekyllrb.com/docs/step-by-step/09-collections/) and [includes](https://jekyllrb.com/docs/step-by-step/05-includes/). The default Jekyll template, by staying minimal, does not help with making those discoverable.

This is why this template showcases and prefills the `_includes` folder and defines a collection in `_config.yml` with both an explicit output and default values that demonstrate the power of collections.


### Systematic use of collections

Jekyll is most often used in a way where the information architecture (i.e. content hierarchy) reflects the folder hierarchy of content files. While a definitely easier way to get started, this has two major drawbacks:

1. Mixing of content hierarchy and dev setup: at the root of your repository lie both the root page and paths that will be exposed on your website and all the weird dev files such as `Gemfile`. This makes it very confusing for non-technical users.
2. Underuse of the powerful metadata management and styling features that can be derived from assigning each piece of content to a category.

This is why this template suggests to only store content in [collections](https://jekyllrb.com/docs/step-by-step/09-collections/). This will help you think about content hierarchy, make sure all your content is in scoped folders, enable the use of default values for layout and metadata for each folder, and let you teach non-technical contributors that they can change anything they want as long as they work in some given folder (which they can, for example, bookmark in their browser).

The only folder that is exposed directly is `assets`, in which files that should be processed as a pass-through are to be stored.


## Tips

### Compress assets

Since your files are stored in Git, and they will be exposed directly, it is a very good idea for the performance of both your public website and production workflow to compress assets _before_ they are committed to the repository. In particular, I strongly recommend using [ImageOptim](https://imageoptim.com/) or an equivalent service to compress images before committing them.


## Get started

### Install Ruby with `rbenv`

We'll use `rbenv` to make sure that the Ruby version is the same across all environments.

#### Install rbenv

For that, we'll start by [installing rbenv](https://github.com/rbenv/rbenv#installation). Make sure you read all the instructions and go through the `rbenv init` stage, otherwise it will not work!

> The alternative to rbenv is RVM. If you have it already installed on your system, or you prefer to use it for any reason, there is no need to switch to rbenv.

#### Specify the Ruby version

Since we want to make sure that we use the same version of all dependencies and runtimes across all environments, and the only one we can't control is the one chosen by GitHub, we'll align all environments with that one. Thus, we'll get the Ruby version we want to use from their published [versions file](https://pages.github.com/versions.json).

The [`.ruby-version` file](https://github.com/rbenv/rbenv#choosing-the-ruby-version) should contain the… version of Ruby we want to use. In our case, that version is given in the `ruby` key of GitHub’s [versions file](https://pages.github.com/versions.json).

### Install Jekyll

We could install Jekyll with `gem`. However, we wouldn't know if later on GitHub updates their versions, and that could yield a conflict later on.

```
gem install bundler --no-ri --no-rdoc
bundle install
```

We can then test that everything went well with:

```
bundle exec jekyll doctor
```

### Set up your website

Edit the `_config.yml` to ensure the metadata matches your setup.

Replace `logo.png` with your own.

You can edit locally with the following options:

```
bundle exec jekyll serve --incremental --watch --safe --strict_front_matter
```

- `incremental` and `watch` improve your developer experience.
- `safe` mirrors GitHub Pages' setup.
- `strict_front_matter` allows to catch errors early.

#### Change the menu

In order to avoid mixing content files with config & dev files, pages are never created at the root: they all get written in collections. In order to add a page to the menu, you can simply add it to `_toplevel`, as long as you set its URL with `permalink`. Prefix their filename with the index at which you'd like them to appear in the menu. The first one (by convention, index `0`) will appear on the left handside of the menu, along with your website logo.


## Publish to GitHub Pages

- Create a repository on GitHub.
- Push your content to it.
- Activate GitHub Pages in the settings.


## Set up Continuous Integration

We'll use [CircleCI](https://circleci.com). They offer a free plan for open-source.
Just log in with GitHub and activate builds for your repository.


## Edit content

### Markdown

- [Syntax reference](https://www.markdownguide.org/basic-syntax).
- [Tutoriel en français](https://openclassrooms.com/fr/courses/1304236-redigez-en-markdown).


# License

[MIT](https://choosealicense.com/licenses/mit/): do whatever you want as long as you don’t sue me.
