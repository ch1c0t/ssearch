require 'fakeredis'
require 'ssearch'

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

index = Ssearch.new 'index'
