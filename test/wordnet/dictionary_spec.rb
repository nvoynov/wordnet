# encoding: UTF-8

require 'pp'
require 'test_helper'
include WordNet

describe Dictionary do

  let(:dict) { Dictionary.instance }

  describe '#definitions' do

    it 'must return definitions for word from @words' do
      dict.definitions('word', :noun).wont_be_empty
      dict.definitions('word', :verb).wont_be_empty
      dict.definitions('word', :adj).must_be_empty
      dict.definitions('word', :adv).must_be_empty
    end

    it 'must return definitions for word from @exceptions' do
      dict.definitions('oxen', :noun).wont_be_empty
    end

    it 'must return [] if word not found' do
      dict.definitions('winters', :noun).must_be_empty
      dict.definitions('oxgpgsz', :noun).must_be_empty
    end

  end

  describe '#lemma' do

  end


end
