# Guard::Shoryuken

[![Build Status](https://secure.travis-ci.org/esebastian/guard-shoryuken.png)](http://travis-ci.org/esebastian/guard-shoryuken)

Guard::Shoryuken automatically starts/stops/restarts Shoryuken workers

*forked from [Guard::Sidekiq](https://github.com/uken/guard-sidekiq)*

## Install

Please be sure to have [Guard](http://github.com/guard/guard) installed before continue.

Install the gem:

    gem install guard-shoryuken

Add it to your Gemfile (inside test group):

    gem 'guard-shoryuken'

Add guard definition to your Guardfile by running this command:

    guard init shoryuken

## Usage

Please read [Guard usage doc](http://github.com/guard/guard#readme).

It is suggested to put the shoryuken guard definition *before* your test/rspec guard if your tests depend on it
being active.

## Guardfile

    guard 'shoryuken', :environment => 'development' do
      watch(%r{^workers/(.+)\.rb})
    end

## Options

You can customize the shoryuken task via the following options:

* `environment`: the rails environment to run the workers in (defaults to `nil`)
* `queue`: the Amazon SQS queue to run (defaults to `default`). Can supply a list of queues here.
* `logfile`: shoryuken defaults to logging to STDOUT. Can specify a file to log to instead.
* `timeout`: shutdown timeout
* `concurrency`: the number of threads to include (defaults to `25`)
* `verbose`: whether to use verbose logging (defaults to `nil`)
* `stop_signal`: how to kill the process when restarting (defaults to `TERM`)
* `require`: location of rails application with workers or file to require (defaults to `nil`)
* `config`: can specify a config file to load queue settings


## Development

 * Source hosted at [GitHub](http://github.com/esebastian/guard-shoryuken)
 * Report issues/Questions/Feature requests on [GitHub Issues](http://github.com/esebastian/guard-shoryuken/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

## Testing the gem locally

    gem install guard-shoryuken-0.x.x.gem

## Building and deploying gem

 * Update the version number in `lib/guard/shoryuken/version.rb`
 * Update `CHANGELOG.md`
 * Build the gem:

    gem build guard-shoryuken.gemspec

 * Push to rubygems.org:

    gem push guard-shoryuken-0.x.x.gem

## Guard::Delayed Authors

[David Parry](https://github.com/suranyami), 
[Dennis Reimann](https://github.com/dbloete)

Ideas for this gem came from [Guard::WEBrick](http://github.com/fnichol/guard-webrick).


## Guard::Resque Authors

[Jacques Crocker](https://github.com/railsjedi)

I hacked this together from the `guard-delayed` gem for use with Resque. All credit go to the original authors though. I just search/replaced and tweaked a few things.

## Guard::Sidekiq Authors
Mark Bolusmjak, 
Pitr Vernigorov, 
[David Parry](https://github.com/suranyami)

Replaces "rescue" with "sidekiq".

## Guard::Shoryuken Authors
[Eduardo Sebastian](https://github.com/esebastian)

Replaces "sidekiq" with "shoryuken".

## Copyright

* Copyright
  * Copyright 2015 Eduardo Sebastian
* License
  * Apache License, Version 2.0
