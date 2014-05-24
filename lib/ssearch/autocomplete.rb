module Ssearch
  class Autocomplete
    def initialize port: 6379, db: 0, ngrams: nil
      @r = Redis.new port: port, db: db
      @ngrams = ngrams
    end

    def << front
      front.each do |ngram, size|
        @r.zincrby ngram[0..2], size, ngram
        (@ngrams.zadd ngram, size, front.path) if @ngrams
      end
      @r.save
    end

    def [] string, amount: 8
      response = []
      @r.zscan_each string[0..2], match: "#{string}*" do |ngram, score|
        response << [ngram, score.to_i]
        break if response.size >= amount
      end
      
      response.sort_by { |_ngram, score| score }.reverse
    end
  end
end
