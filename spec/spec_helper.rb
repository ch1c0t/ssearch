require 'fakeredis'
require 'ssearch'
require 'pathname'

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

def seed_test_ssearch
  s = Ssearch.new 

  file = Pathname.new './spec/sentences.data'
  lines = file.readlines

  lines.each_with_index do |line, index|
    s.add line, index unless line.empty?
  end

  s
end
