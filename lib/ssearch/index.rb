class Ssearch
  class Index
    def initialize port, size
      @r = Redis.new port: port, db: size
      @size = size
    end

    def add unigrams, id
      tokens = @size > 0 ? TokenFormer.form(from: unigrams, size: @size) : unigrams
      tokens.each { |token| @r.sadd token, id }
    end

    def find *tokens
      @r.sinter *tokens
    end
  end
end
