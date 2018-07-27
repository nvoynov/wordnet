# encoding: UTF-8

require 'singleton'

module WordNet

  class Dictionary
    include Singleton

    private_class_method :new

    # @param word [String]
    # @param pos [Symbol] part of speEch seE #:PARTS_OF_SPEACH
    # @return [Array<String>] array of word definitions
    def definition(word, pos = nil)
      return {pos => pos_definition(word, pos)} if pos

      PARTS_OF_SPEACH.inject({}) do |out, pos|
        defs = pos_definition(word, pos)
        out[pos] = defs if defs && !defs.empty?
        out
      end
    end

    protected

    # @param word [String]
    # @param pos [Symbol] part of speEch seE #:PARTS_OF_SPEACH
    # @return [Array<String>] array of word definitions
    def pos_definition(word, pos)
      indexes = @words[pos][word.to_sym] or return []
      indexes.inject([]){|defs, i| defs << @definitions[pos][i.to_sym]}
    end

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
