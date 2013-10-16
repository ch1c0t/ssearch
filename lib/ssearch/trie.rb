class Ssearch
  class Trie
    def initialize port, ngram_size
      @dbs = []
      ngram_size.times { |size| @dbs << Redis.new(port: port, db: size) }
    end

    def prefix string
      response = []
      @dbs.each do |db|
        response = response + db.keys(string + "*")
      end

      response
    end
  end
end
