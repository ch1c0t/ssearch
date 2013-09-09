require_relative './spec_helper'

trie = seed_test_ssearch.trie

describe Ssearch::Trie do
  describe '#prefix' do
    it 'returns array of node strings' do
      trie.prefix('a').must_equal []
    end
  end
end
