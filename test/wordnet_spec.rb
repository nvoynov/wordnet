require "test_helper"

describe WordNet do

  it 'must have version' do
    WordNet::VERSION.wont_be_nil
  end

end
