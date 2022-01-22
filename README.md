[![Maintainability](https://api.codeclimate.com/v1/badges/0e2629515335c72ef80d/maintainability)](https://codeclimate.com/github/saiqulhaq/firebase_dynamic_link/maintainability)
[![Audit](https://github.com/saiqulhaq/firebase_dynamic_link/actions/workflows/audit.yml/badge.svg)](https://github.com/saiqulhaq/firebase_dynamic_link/actions/workflows/audit.yml)
[![Test](https://github.com/saiqulhaq/firebase_dynamic_link/actions/workflows/test.yml/badge.svg)](https://github.com/saiqulhaq/firebase_dynamic_link/actions/workflows/test.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0e2629515335c72ef80d/test_coverage)](https://codeclimate.com/github/saiqulhaq/firebase_dynamic_link/test_coverage)

Firebase Dynamic Link is a tool to create a deep link of your webpage. It can be a tool to create a short link like Bit.ly too

- [Setup](#setup)
- [Installation](#installation)
- [Usage](#usage)
  - [Configure the HTTP client](#configure-the-http-client)
  - [Shorten a link](#shorten-a-link)
  - [Shorten parameters](#shorten-parameters)
  - [More than one firebase project](#more-than-one-firebase-project)
- [CHANGELOG](#changelog)
  - [V1.0.5](#v105)
  - [V1.0.3](#v103)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)


## Setup

Before you begin, you need to register at Firebase, and find following data:
1. Firebase API key

   Open Open the Settings page of the Firebase console. If you are prompted to choose a project, select your Firebase project from the menu. The API key is a Web API Key field, you need to a note this key.
2. Dynamic Links domain

   In the Firebase console, open the Dynamic Links section, accept the terms of service if prompted, and copy the dynamic links host.
   Usually it's like `https://xxx.page.link`. You can use your own custom domain to make it shorter. Reference: https://firebase.google.com/docs/dynamic-links/custom-domains

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
      config.adapter = :httpclient # optional, default is net_http

      # required, taken as default firebase api key when api_key parameter isn't passed to FirebaseDynamicLink::Client constructor
      config.api_key = 'API_KEY'

      # default 'UNGUESSABLE'
      config.suffix_option = 'SHORT' or 'UNGUESSABLE'

      # required
      config.dynamic_link_domain = 'https://xyz.app.goo.gl'

      # default 3 seconds
      config.timeout = 3

      # default 3 seconds
      config.open_timeout = 3
    end
```

### Shorten a link
This method shortens a link with up to the first parameter in tact. Use this method if you do not have more than one
parameter in the URL. Shortening an URL with more than one parameters will result in truncation of parameters after the
first one.

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
This method allows shortening of an URL with multiple parameters.

```ruby
    client = FirebaseDynamicLink::Client.new
    link = "http://domain.com/path/path?key1=value1&key2=val2&key3=val3"
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
      },
      ios_info: {},
      navigation_info: {},
      analytics_info: {},
      social_meta_tag_info: {}
    }

    # options argument is optional
    result = client.shorten_parameters(parameters, options)
```

If request successful, then the result should be like following hash object

Or if the request reached daily quota, client will throw `FirebaseDynamicLink::QuotaExceeded` error

```ruby
    {
      :link=>"https://--.app.goo.gl/ukph",
      :preview_link=>"https://--.app.goo.gl/ukph?d=1",
      :warning=>[
           {
             "warningCode"=>"UNRECOGNIZED_PARAM",
             "warningMessage"=>"..."
           },
           {
             "warningCode"=>"..."
           },
           {
             "warningCode"=>"..."
           }
        ]
    }
```

Otherwise it will throw `FirebaseDynamicLink::ConnectionError` error, with message = http error message

### More than one firebase project

If you have more than one firebase project you can pass your `api_key` to `FirebaseDynamicLink::Client` constructor additionally to `FirebaseDynamicLink` configuration.
Api key provided by constructor has precendece over this provided by `FirebaseDynamicLink` configuration.

```
    client = FirebaseDynamicLink::Client.new(api_key: 'API_KEY')
```


## CHANGELOG

See https://github.com/saiqulhaq/firebase_dynamic_link/releases

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Copy `.env.template` to `.env` and update the values.
Then, run `bundle exec appraisal install && bundle exec appraisal rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saiqulhaq/firebase_dynamic_link. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FirebaseDynamicLink project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/saiqulhaq/firebase_dynamic_link/blob/master/CODE_OF_CONDUCT.md).
