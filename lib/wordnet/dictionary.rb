# encoding: UTF-8

require 'singleton'

module WordNet

  class Dictionary
    include Singleton

    attr_reader :exclusions

    private_class_method :new

    # @param word [String]
    # @return [Hash<Symbol, String>] `{ part_of_speach: lemma }`
    def find(word)
      PARTS_OF_SPEACH.inject({}) do |out, pos|
        lem = lemma(word, pos)
        out[pos] = lem if lem
        out
      end
    end

    # TODO check for word is phrase
    # @param word [String]
    # @param pos [Symbol] part of speEch see #::PARTS_OF_SPEACH
    # @return [String] lemma of word
    def lemma(word, pos)
      e = exclusion(word, pos)
      return e if e
      substitutions(word, pos).each{|s| return s if word?(s, pos)}
      return word.downcase if word?(word, pos)
      nil
    end

    # TODO search for word is a phrase
    # TODO split by ';' excluding semicolon inside an example
    # @param word [String]
    # @param pos [Symbol] part of speEch see #::PARTS_OF_SPEACH
    # @return [Array<Array<String>>] array of word definitions and examples  ```[definition, example1, example2, ...]```
    def definitions(word, pos)
      indexes = @words[pos][word.downcase.to_sym] || []
      indexes.inject([]){|defs, i|
        defs << @definitions[pos][i.to_sym].split(';').map(&:strip)
      }
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

    def word?(word, pos)
      @words[pos].key?(word.downcase.to_sym)
    end

    def exclusion(word, pos)
      e = @exclusions[pos][word.downcase.to_sym]
      return e.to_s if e
      nil
    end

    # @param word [String] word to find all possible substitutions
    # @param pos [Symbol] part of speach see #::paPARTS_OF_SPEACH
    # @return [Array<String>] of possible subsitutions for the word
    def substitutions(word, pos)
      w = word.downcase
      SUFFIX_SUBSTITUTIONS[pos]
        .select{|s| w.end_with?(s[0])}
        .map{|s| w.gsub(/#{s[0]}$/, '') + s[1]}
    end

    PARTS_OF_SPEACH = [:noun, :verb, :adj, :adv].freeze

    SUFFIX_SUBSTITUTIONS = {
      :noun => [
        ['s',    ''   ],
        ['ses',  's'  ],
        ['ves',  'f'  ],
        ['xes',  'x'  ],
        ['zes',  'z'  ],
        ['ches', 'ch' ],
        ['shes', 'sh' ],
        ['men',  'man'],
        ['ies',  'y'  ]
      ],
      :verb => [
        ['s',   '' ],
        ['ies', 'y'],
        ['es',  'e'],
        ['es',  '' ],
        ['ed',  'e'],
        ['ed',  '' ],
        ['ing', 'e'],
        ['ing', '' ]
      ],
      :adj =>  [
        ['er',  '' ],
        ['est', '' ],
        ['er',  'e'],
        ['est', 'e']
      ],
      :adv =>  []
    }.freeze

  end
end

if __FILE__ == $0
  require 'pp'
  dict = WordNet::Dictionary.instance

  pp dict.definitions('dictionary', :noun)
  pp dict.lemma('dictionaries', :noun)
  pp dict.lemma('oxen', :noun)
  pp dict.find('winters')
  pp dict.definitions('winter', :noun)
  pp dict.definitions('winter', :verb)

  definitions = dict.definitions('word', :noun)
  puts '-= word, noun =-'
  definitions.each_with_index do |item, index|
    definition, *examples = item
    puts "#{index + 1}) #{definition}"
    examples.each{|e| puts "- #{e}"}
  end

end
