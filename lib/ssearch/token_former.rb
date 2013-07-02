class Ssearch
  module TokenFormer
    extend self

    def form from: [], size: 4
      tokens = []
      from.each_index do |index|
        last = size + index
        tokens << from[index..last].join(' ') unless from[last].nil?
      end
      tokens
    end
  end
end
