module Ssearch
  class Autocomplete
    def initialize port: 6379, db: 0
      @r = Redis.new port: port, db: db
    end

    def << front
      front.each do |ngram, size|
        @r.zadd ngram[0..2], size, ngram
      end
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
