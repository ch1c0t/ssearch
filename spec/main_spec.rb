require_relative './spec_helper'

ssearch = Ssearch.new 

file = Pathname.new './spec/sentences.data'
lines = file.readlines

lines.each_with_index do |line, index|
  ssearch.add line, index unless line.empty?
end

describe 'find' do
  it 'returns unigram ids' do
    assert ssearch.find('term') == ["0", "10"]
    assert ssearch.find('information') == ["0", "1", "2", "3", "5", "6", "7", "9", "17", "20", "27", "28"]
  end

  it 'returns bigram ids' do
    assert ssearch.find('of the') == ["0", "11", "18", "25"]
    assert ssearch.find('information retrieval') == ["0", "1", "2", "5", "6", "17", "27", "28"]
  end

  it 'returns trigram ids' do
    assert ssearch.find('the personal search') == ["34"]
  end
end
