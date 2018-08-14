# encoding: UTF-8

require 'singleton'

module WordNet

  class Dictionary
    include Singleton

    private_class_method :new

    # @param word [String]
    # @param pos [Symbol] part of speEch see #::PARTS_OF_SPEACH
    # @return [String] lemma of word
    def lemma(word, pos)
      w = word.downcase.to_sym
      w = @exclusions[pos][w] unless @words[pos].key?(w)
      return w.to_s if @words[pos].key?(w)
      # TODO try substitutions
      nil
    end

    # TODO split by ';' excluding semicolon inside an example
    # @param word [String]
    # @param pos [Symbol] part of speEch see #::PARTS_OF_SPEACH
    # @return [Array<Array<String>>] array of word definitions and examples  ```[definition, example1, example2, ...]```
    def definitions(word, pos)
      w = word.downcase.to_sym
      w = @exclusions[pos][w] unless @words[pos].key?(w)
      # @words[pos].key?(w) or w = @exclusions[pos][w]
      indexes = @words[pos][w] or return []
      indexes.inject([]){|defs, i|
        defs << @definitions[pos][i.to_sym].split(';').map(&:strip)
      }
    end

    # @param word [String] word to check
    # @param pos [Symbol] part of speEch seE #:PARTS_OF_SPEACH
    # @return [Boolean]
    def include?(word, pos)
      # @words[pos][word.to_sym] and return true
      w = word.downcase.to_sym
      return true if @words[pos][w]
      return true if @exclusions[pos][w]
      false
    end

    protected

    def initialize
      @words = {}
      @exclusions = {}
      @definitions = {}
      load_dictionary
    end

    def load_dictionary
      PARTS_OF_SPEACH.each do |pos|
        load_index(pos)
        load_exc(pos)
        load_data(pos)
      end
    end

    def load_index(pos)
      @words[pos] = {}
      source = File.join(File.dirname(__dir__), 'dict', "index.#{pos.to_s}")
      File.foreach(source) do |line|
        word = line.split(/\s+/)[0].to_sym
        defs = line.scan(/\d{8}/)
        @words[pos][word.to_sym] = defs
      end
    end

    def load_exc(pos)
      @exclusions[pos] = {}
      source = File.join(File.dirname(__dir__), 'dict', "#{pos.to_s}.exc")
      File.foreach(source) do |line|
        *forms, word = line.split(/\s+/)
        forms.each do |form|
          @exclusions[pos][form.to_sym] = word.to_sym
        end
      end
    end

    def load_data(pos)
      @definitions[pos] = {}
      source = File.join(File.dirname(__dir__), 'dict', "data.#{pos.to_s}")
      regexp = /^([\d]+)\s[^|]+\|([\s\S]+)$/
      File.foreach(source) do |line|
        next if line[0] == ' '
        index, definition = line.match(regexp).captures
        @definitions[pos][index.to_sym] = definition.chomp.strip
       end
    end

    PARTS_OF_SPEACH = [:noun, :verb, :adj, :adv].freeze

  end
end
