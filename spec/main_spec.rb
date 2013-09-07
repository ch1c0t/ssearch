require_relative './spec_helper'

s = seed_test_ssearch

describe 'find' do
  it 'returns unigram ids' do
    assert s.find('term') == ["0", "10"]
    assert s.find('information') == ["0", "1", "2", "3", "5", "6", "7", "9", "17", "20", "27", "28"]
  end

  it 'returns bigram ids' do
    assert s.find('of the') == ["0", "11", "18", "25"]
    assert s.find('information retrieval') == ["0", "1", "2", "5", "6", "17", "27", "28"]
  end

  it 'returns trigram ids' do
    assert s.find('the personal search') == ["34"]
  end

  it 'returns empty array as empty string prompted' do
    assert s.find('') == []
  end
end
