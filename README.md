# WordNet

`wordnet` gem provides an interface to [WordNet®](https://wordnet.princeton.edu/) that is a Lexical Database for English. It loads WordNet database files (`index.<pos>`, `<pos>.exc`, and `data.pos`) and provides the following functions:

1. definitions(word, pos);
2. lemma(word, pos);
3. find(word).

The WordNet::Dictionary does not support sentences at the moment, instead of fact that [WordNet®](https://wordnet.princeton.edu/) has a lot of them. And the first following task will be checking if the word is a  phrase or if the word is included in phrases of the dictionary.

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

dict = WordNet::Dictionary.instance

pp dict.definitions('dictionary', :noun)
pp dict.lemma('dictionaries', :noun)
pp dict.lemma('oxen', :noun)
pp dict.find('winters')
pp dict.definitions('winter', :noun)
pp dict.definitions('winter', :verb)
```

For WordNet database 3.1 the code above will return the following:

```
[["a reference book containing an alphabetical list of words with information about them"]]

"dictionary"

"ox"

{:noun=>"winter", :verb=>"winter"}

[["the coldest season of the year",
  "in the northern hemisphere it extends from the winter solstice to the vernal equinox"]]

[["spend the winter",
  "\"We wintered on the Riviera\"",
  "\"Shackleton's men overwintered on Elephant Island\""]]
```

Note that `definition` returns array of definitions where each definition is array where its first item is the definition and rest of items are examples.

Suppose we want get definitions for `word`

```ruby
definitions = dict.definitions('word', :noun)
puts '-= word, noun =-'
definitions.each_with_index do |item, index|
  definition, *examples = item
  puts "#{index + 1}) #{definition}"
  examples.each{|e| puts "- #{e}"}
end
```

The code above will return

```
-= word, noun =-
1) a unit of language that native speakers can identify
- "words are the blocks from which sentences are made"
- "he hardly said ten words all morning"
2) a brief statement
- "he didn't say a word about it"
3) information about recent and important events
- "they awaited news of the outcome"
4) a verbal command for action
- "when I give the word, charge!"
5) an exchange of views on some topic
- "we had a good discussion"
- "we had a word or two about it"
6) a promise
- "he gave his word"
7) a string of bits stored in computer memory
- "large computers use words up to 64 bits long"
8) the divine word of God
- the second person in the Trinity (incarnate in Jesus)
9) a secret word or phrase known only to a restricted group
- "he forgot the password"
10) the sacred writings of the Christian religions
- "he went to carry the Word to the heathen"
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
