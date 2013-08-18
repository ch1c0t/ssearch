require 'redis'

require "ssearch/version"
require "ssearch/token_former"
require "ssearch/index"

class Ssearch
  def initialize( segmenter:  -> string { string.split /\s+|\b/ },
                  redis_port: 6379,
                  ngram_size: 4)
    @ngram_size, @redis_port, @segmenter = ngram_size, redis_port, segmenter

    @indexes = []
    @ngram_size.times { |size| @indexes << Index.new(redis_port, size) }
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
    Redis.new(port: @redis_port).flushall
  end
end
