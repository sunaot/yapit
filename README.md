# Yapit

[![Build Status](https://travis-ci.org/sunaot/yapit.png?branch=master)](https://travis-ci.org/sunaot/yapit)

Yet another simple Pit library.

## Installation

    $ gem install yapit

## Usage

```
require 'yapit'

Yapit.configure do |c|
  c.root = '/path/to/pit/directory' # ~/.pit for default
  c.default_profile = 'twitter'     # 'default' for default
end

yapit = Yapit.new('profile_name')   # or use default_profile
auth = yapit.get('twitter.com')
puts auth['id'], auth['id']
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
