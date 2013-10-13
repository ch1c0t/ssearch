class Ssearch
  class Trie
    def initialize args = {}
      @r = Redis.new :port => args[:port]
    end

    def prefix string
      @r.keys(string + "*")
    end
  end
end
