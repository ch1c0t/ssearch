require_relative './spec_helper'

trie = seed_test_ssearch.trie

describe Ssearch::Trie do
  describe '#prefix' do
    it 'returns array of node strings' do
      trie.prefix('ab').must_equal ["above", "able"]
    end
  end
end
