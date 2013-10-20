class Ssearch
  class Trie
    def initialize port, ngram_size
      @dbs = []
      ngram_size.times { |size| @dbs << Redis.new(port: port, db: size) }

      @nodes = Redis.new port: port, db: 15
    end

    def prefix string, size: 7
      create_node_for string unless @nodes.exists string

      @nodes.zrevrange(string, 0, size, with_scores: true).map do |(string, cardinality)|
        [string, cardinality.to_i]
      end
    end

    private

    def create_node_for string
      @dbs.each do |db|
        autocompletions = db.keys(string + "*")
        autocompletions.each do |autocompletion|
          @nodes.zadd string, db.scard(autocompletion), autocompletion
        end
      end
    end
  end
end
