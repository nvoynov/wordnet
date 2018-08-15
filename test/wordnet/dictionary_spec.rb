# encoding: UTF-8

require 'pp'
require 'test_helper'
include WordNet

class Substitution < Dictionary

  def initialize
  end

  def substitutions(word, pos)
    super(word, pos)
  end
end

describe Dictionary do

  let(:dict) { Dictionary.instance }
  let(:subs) { Substitution.instance }

  describe '#substitutions' do
    it 'must ..' do
      subs.substitutions('desks', :noun).must_equal ['desk']
    end
  end

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

    it 'must return nil unless lemma found' do
      dict.lemma('bla-bla-bla-bla', :noun).must_be_nil
      dict.lemma('bla-bla-bla-bla', :verb).must_be_nil
      dict.lemma('bla-bla-bla-bla', :adj).must_be_nil
      dict.lemma('bla-bla-bla-bla', :adv).must_be_nil
    end

    it 'must return lemma if word is lemma itself' do
      dict.lemma('Winter', :noun).must_equal 'winter'
      dict.lemma('WINTER', :noun).must_equal 'winter'
      dict.lemma('wINter', :noun).must_equal 'winter'
    end

    it 'must return lemma for word in @exclusions' do
      dict.lemma('ottomans', :noun).must_equal 'ottoman'
      dict.lemma('othman', :noun).must_equal   'ottoman'

      dict.lemma('assegais', :noun).must_equal 'assegai'
      dict.lemma('assagai', :noun).must_equal  'assegai'

      dict.lemma('aspersoria', :noun).must_equal 'aspersorium'

      dict.lemma('oxen', :noun).must_equal 'ox'
      dict.lemma('geese', :noun).must_equal 'goose'
      dict.lemma('mice', :noun).must_equal 'mouse'
    end

    it 'must return lemma for an noun' do
      dict.lemma('analyses', :noun).must_equal 'analysis'
      dict.lemma('desks', :noun).must_equal 'desk'
    end

    it 'must return lemma for an verb' do
      dict.lemma('hired', :verb).must_equal 'hire'
      dict.lemma('worried', :verb).must_equal 'worry'
      dict.lemma('partying', :verb).must_equal 'party'
    end

    it 'must return lemma for an adjective' do
      dict.lemma('hotter', :adj).must_equal 'hot'
      dict.lemma('better', :adj).must_equal 'well'
    end

    it 'must return lemma for an adverb' do
      dict.lemma('best', :adv).must_equal 'well'
      dict.lemma('best', :adv).wont_equal 'good'
    end
  end

  describe '#find' do

    it 'must return all pos-es and lemmas' do
      dict.find('winter').must_equal({noun: "winter", verb: "winter"})
      dict.find('winters').must_equal({noun: "winter", verb: "winter"})

      dict.find('survey').must_equal({noun: "survey", verb: "survey"})
      # pp dict.find('surveys')
      dict.find('surveyed').must_equal({verb: "survey"})
      dict.find('surveying').must_equal({noun: "surveying", verb: "survey"})

      dict.find('plays').must_equal({noun: 'play', verb: 'play'})
      dict.find('fired').must_equal({verb: 'fire', adj: 'fired'})
      dict.find('slower').must_equal({adj: 'slow', adv: 'slower'})

      dict.find('higher').must_equal({:adj=>"high"})

      dict.find('asdfassda').must_equal({})
    end

  end

end
