module Ssearch
  class Front
    include Enumerable

    def initialize path, document,
                   segmenter: -> string { string.split /\s+|\b/ }
      @segmenter = segmenter
      @document = document
      @path = Pathname.new path

      if @path.exist? 
        @reverse_index = DB.new @path
      else
        index document
      end
    end
    
    def find string, amount: 16
      tokens = @segmenter[string]

      if tokens.size > 1 && result = @reverse_index[tokens.to_msgpack]
        ids = MessagePack.unpack result
        ids.take(amount).map { |id| @document[id] }
      else
        []
      end
    end

    def each &b
      @reverse_index.map do |ngram, ids|
        string = MessagePack.unpack(ngram).join ' '
        size   = MessagePack.unpack(ids).size

        [string, size]
      end.each &b
    end

    private

    def index document
      @forward_index = document.map { |unit| @segmenter[unit] }
      reverse_index = {}
      
      @forward_index.each_with_index do |tokens, id|
        tokens.each_cons(2).with_index do |bigram, position|
          reverse_index[bigram] ||= []
          reverse_index[bigram] << [id, position]
        end
      end

      reverse_index.select! { |_, occurrences| occurrences.size >= 8 }
      reverse_index = reverse_index.each_with_object({}) do |(ngram, occurrences), h|
          h.merge! (find_ngrams_in occurrences)
      end.merge reverse_index


      @reverse_index = DB.new @path
      reverse_index.each do |k, v|
        @reverse_index[k.to_msgpack] = v.map { |id, position| id }.to_msgpack
      end
      @reverse_index.flush
    end

    def find_ngrams_in occurrences, size = 2
      ngrams = {}

      occurrences.each do |id, position|
        ngram = @forward_index[id][position..position+size]

        ngrams[ngram] ||= []
        ngrams[ngram] << [id, position]
      end

      ngrams.select { |_, occurrences| occurrences.size > 1 }
    end
  end
end
