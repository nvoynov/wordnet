require "wordnet/version"
require "wordnet/dictionary"

module WordNet
  extend self

  def dictionary
    Dictionary.instance
  end

end
