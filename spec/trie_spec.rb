require_relative './spec_helper'

trie = seed_test_ssearch.trie

describe Ssearch::Trie do
  describe '#prefix' do
    it 'returns array of node strings' do
      expected = ["above", "able", "above .", "able to", "able to classify", "able to build", "able to classify new", "able to build systems"]
      trie.prefix('ab').must_equal expected
    end
  end
end
