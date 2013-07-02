class Ssearch
  class Index
    def initialize name, size
      @namespace = "#{name}:#{size}"
      @size = size
    end

    def add unigrams, id
      tokens = @size > 0 ? TokenFormer.form(from: unigrams, size: @size) : unigrams
      tokens.each { |token| R.sadd "#{@namespace}:#{token}", id }
    end

    def find *tokens
      tokens.map! { |token| "#{@namespace}:#{token}" }
      R.sinter *tokens
    end
  end
end
