module Ssearch
  class Manager
    attr_accessor :fronts

    def initialize port: 6379, segmenter: -> string { string.split /\s+|\b/ }
      @fronts = []
      @ngrams = Redis.new port: port, db: 1
      @autocomplete = Autocomplete.new port: port, ngrams: @ngrams
      @segmenter = segmenter
    end

    def << front
      @autocomplete << front
      @fronts << front
    end

    def autocomplete prefix
      @autocomplete[prefix]
    end

    def find string, amount: 16
      paths = front_paths_which_contain string, with_scores: true

      granted_amount = 0
      needed_paths = paths.take_while do |(_path, score)|
        granted_amount += score
        granted_amount < amount
      end.map { |path,_score| path }

      amount_from_each = (amount/needed_paths.size + 1)
      needed_paths.map do |path|
        front = @fronts.find { |f| f.path.to_s == path }
        front.find string, amount: amount_from_each
      end.reduce(:+).take amount
    end

    private

    def front_paths_which_contain string, with_scores: false
      (@ngrams.zrevrange (preprocess string), 0, -1, with_scores: with_scores)
        .map { |path, score| [path, score.to_i] }
    end

    def preprocess string
      @segmenter[string].join ' '
    end
  end
end
