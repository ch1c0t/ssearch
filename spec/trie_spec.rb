require_relative './spec_helper'

trie = seed_test_ssearch.trie

describe Ssearch::Trie do
  describe '#prefix' do
    it 'returns array of node strings with count of its occurances' do
      trie.prefix('a').must_equal [
                                    ["a", 16], 
                                    ["and", 15], 
                                    ["as", 7], 
                                    ["also", 5], 
                                    ["an", 4], 
                                    ["a set of", 3], 
                                    ["at", 3], 
                                    ["a set", 3]
                                  ]
    end
  end
end
