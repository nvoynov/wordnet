# Wordnet

`wordnet` gem provides an interface to [WordNet®](https://wordnet.princeton.edu/) that is a Lexical Database for English. At the moment all that it does loading WordNet database files (`index.<pos>`, `<pos>.exc`, and `data.pos`) and providing function for getting definition of word `definition(word, pos = nil)`. The optional parameter `pos` defines part of speech.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wordnet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wordnet

## Usage

```ruby
require 'wordnet'
require 'pp'

dict = WordNet.dictionary
pp dict.definition('abandon')
pp dict.definition('abandon', :noun)
```

For WordNet database 3.1 the code above will return the following two hashes:

```
{:noun=>
  ["the trait of lacking restraint or control; reckless freedom from inhibition or worry; \"she danced with abandon\"",
   "a feeling of extreme emotional intensity; \"the wildness of his anger\""],
 :verb=>
  ["forsake, leave behind; \"We abandoned the old car in the empty parking lot\"",
   "give up with the intent of never claiming again; \"Abandon your life to God\"; \"She gave up her children to her ex-husband when she moved to Tahiti\"; \"We gave the drowning victim up for dead\"",
   "leave behind empty; move out of; \"You must vacate your office by tonight\"",
   "stop maintaining or insisting on; of ideas or claims; \"He abandoned the thought of asking for her hand in marriage\"; \"Both sides have to give up some claims in these negotiations\"",
   "leave someone who needs or counts on you; leave in the lurch; \"The mother deserted her children\""]}

{:noun=>
  ["the trait of lacking restraint or control; reckless freedom from inhibition or worry; \"she danced with abandon\"",
   "a feeling of extreme emotional intensity; \"the wildness of his anger\""]}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nvoynov/wordnet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Wordnet project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/wordnet/blob/master/CODE_OF_CONDUCT.md).
