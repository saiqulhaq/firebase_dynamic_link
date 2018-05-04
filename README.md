# FirebaseDynamicLink

[![Build Status](https://travis-ci.org/saiqulhaq/firebase_dynamic_link.svg?branch=master)](https://travis-ci.org/saiqulhaq/firebase_dynamic_link)
[![Maintainability](https://api.codeclimate.com/v1/badges/0e2629515335c72ef80d/maintainability)](https://codeclimate.com/github/saiqulhaq/firebase_dynamic_link/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0e2629515335c72ef80d/test_coverage)](https://codeclimate.com/github/saiqulhaq/firebase_dynamic_link/test_coverage)
[![Gem Version](https://badge.fury.io/rb/firebase_dynamic_link.svg)](https://badge.fury.io/rb/firebase_dynamic_link)

Opiniated Ruby Firebase Dynamic Links Short Links client 

based on reference https://firebase.google.com/docs/reference/dynamic-links/link-shortener

## Installation

Add this line to your application's Gemfile:

    gem 'firebase_dynamic_link'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install firebase_dynamic_link

## Usage

### Configure the HTTP client

```ruby
    FirebaseDynamicLink.configure do |config|
      # the adapter should be supported by Faraday
      # more info look at https://github.com/lostisland/faraday/tree/master/test/adapters
      # Faraday.default_adapter is the default adapter
      config.adapter = :httpclient

      # required
      config.api_key = 'API_KEY'

      # default 'UNGUESSABLE'
      config.suffix_option = 'SHORT' or 'UNGUESSABLE'

      # required, Don't put http://
      config.dynamic_link_domain = 'xyz.app.goo.gl'

      # default 3 seconds
      config.timeout = 3 

      # default 3 seconds
      config.open_timeout = 3
    end
```

### Shorten a link

```ruby
    client = FirebaseDynamicLink::Client.new
    link = "http://domain.com/path/path"
    options = {
      # optional, to override default suffix default config 
      suffix_option: '', 

      # optional, to override default dynamic_link_domain default config
      dynamic_link_domain: '', 

      # optional, timeout of each request of this instance
      timeout: 10, 

      # optional, open timeout of each request of this instance
      open_timeout: 10
    }

    # options argument is optional
    result = client.shorten_link(link, options)
```

### Shorten parameters

```ruby
    client = FirebaseDynamicLink::Client.new
    options = {
      # optional, to override default suffix default config 
      suffix_option: '', 

      # optional, to override default dynamic_link_domain default config
      dynamic_link_domain: '', 

      # optional, timeout of each request of this instance
      timeout: 10, 

      # optional, open timeout of each request of this instance
      open_timeout: 10
    }

    parameters = {
      link: link,
      android_info: {
        android_package_name: name,
      }
      ios_info: {},
      navigation_info: {},
      analytics_info: {},
      social_meta_tag_info: {}
    }

    # options argument is optional
    result = client.shorten_parameters(parameters, options)
```

if request successful, then the result should be like following hash object

or if the request reached daily quota, client will throw `FirebaseDynamicLink::QuotaExceeded` error

```ruby
    { 
      :link=>"https://--.app.goo.gl/ukph", 
      :preview_link=>"https://--.app.goo.gl/ukph?d=1", 
      :warning=>[
           { 
             "warningCode"=>"UNRECOGNIZED_PARAM",
             "warningMessage"=>"..."}, 
           {
             "warningCode"=>"..."
           }, 
           {
             "warningCode"=>"..."
           }
        ]
    }
```

otherwise it will throw `FirebaseDynamicLink::ConnectionError` error, with message = http error message

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saiqulhaq/firebase_dynamic_link. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FirebaseDynamicLink project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/saiqulhaq/firebase_dynamic_link/blob/master/CODE_OF_CONDUCT.md).
