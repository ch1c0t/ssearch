require_relative './spec_helper'

trie = seed_test_ssearch.trie

describe Ssearch::Trie do
  describe 'when new prefix is looked up' do
    it 'creates new node from reverse indexes'
    it 'returns array of node strings'
  end

  describe 'when existing prefix is looked up' do
    it 'returns from the node without bothering #keys'
  end

  describe '#prefix' do
    it 'returns array of node strings' do
      trie.prefix('a').must_equal []
    end
  end
end
