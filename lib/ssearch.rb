require 'redis'

require "ssearch/version"
require "ssearch/token_former"
require "ssearch/index"

class Ssearch
  def initialize( name,
    redis:      Redis.new,
    segmenter:  -> string { string.split /\s+|\b/ },
    ngram_size: 4)
    @redis, @segmenter, @ngram_size = redis, segmenter, ngram_size
    Index.const_set :R, redis

    @indexes = []
    @ngram_size.times { |size| @indexes << Index.new(name, size) }
  end

  def add string, id
    unigrams = @segmenter.call string

    @indexes.each { |index| index.add unigrams, id }
  end

  def find substring
    unigrams = @segmenter.call substring
    
    index, tokens = if unigrams.size <= @ngram_size
      size = unigrams.size - 1
      tokens = TokenFormer.form from: unigrams, size: size
      [size, tokens]
    else
      [0, unigrams]
    end

    @indexes[index].find *tokens
  end

  def flush
    @redis.flushdb
  end
end
