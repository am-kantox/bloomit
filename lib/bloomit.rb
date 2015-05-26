require "bloomit/version"

module Bloomit
  DLM_FACTOR = 0.8 # 1.44269
  DLM_FACTOR_RGB = [1.805, 3.26, 7.95]
  DLM_NORMALIZER = (Math::exp(1.0 / DLM_FACTOR) - 1.0) ** 2.0 / Math::exp(1.0 / DLM_FACTOR)

  module Numeric

    # sum_(n=0)^N n/(exp(n/pi)) = (e^(-N/pi) (N+e^((N+1)/pi)-e^(1/pi) (N+1)))/(e^(1/pi)-1)^2
    # -(e^(1/pi-N/pi) N)/(e^(1/pi)-1)^2+(e^(-N/pi) N)/(e^(1/pi)-1)^2-e^(1/pi-N/pi)/(e^(1/pi)-1)^2+e^(1/pi)/(e^(1/pi)-1)^2
    def dlm_slice n
      # DLM_NORMALIZER * (0..n).inject(0.0) { |memo, i| memo + (Math::E ** (-i / DLM_FACTOR)) * i }
      n, sign = n.abs, n < 0 ? -1 : 1
      denominator = ((Math::exp(1.0 / DLM_FACTOR) - 1.0) ** 2.0)
      nominator = n * (Math::exp(-n / DLM_FACTOR) - Math::exp((1.0 - n) / DLM_FACTOR)) +
                  Math::exp(1.0 / DLM_FACTOR) - Math::exp((1.0 - n) / DLM_FACTOR)

      DLM_NORMALIZER * nominator / denominator * sign
    end

    def dlm_neighbor_slice n
      n.zero? ? n : dlm_slice(n) - dlm_slice(n - (n / n.abs))
    end
    module_function :dlm_slice, :dlm_neighbor_slice
  end

  attr_reader :usage
  def self.included base
    @usage = :included
  end
  def self.extended base
    @usage = :extended
  end


  module String
    # Damerau Levenshtein Matiushkin distance :)
    #   @return [Float] in the range [0..1), 0 for exact match and 1 for totally different strings
    def dlm_distance s1, s2
      (0..[s1, s2].map(&:length).max).inject(0.0) do |memo, cnt|
        memo + DamerauLevenshtein.distance(s1[0...cnt], s2[0...cnt]) * (Math::E ** (-cnt / DLM_FACTOR))
      end * DLM_NORMALIZER
    end
    private :dlm_distance

    DLM_ALLOWED = 'etaoinsrhdlucmfywgpbvkxqjz0123456789 '.reverse.split(//) #('a'..'z').to_a | ('0'..'9').to_a
    DLM_ALLOWED_SIZE = DLM_ALLOWED.size - 1
    # Current impl suxx because it fails on any unicode. ASCII only in 2015, shame on me
    # /\p{L}/ - 'Letter'
    # /\p{M}/ - 'Mark'
    # /\p{N}/ - 'Number'
    # /\p{P}/ - 'Punctuation'
    # /\p{S}/ - 'Symbol'
    # /\p{Z}/ - 'Separator'
    # /\p{C}/ - 'Other'
    def to_color str, **options # options NOT IMPLEMENTED todo language, case insensitivity, etc
      "#%02X%02X%02X" % ((0...str.length).inject([0,0,0]) do |memo, i|
        sym = str[i]
        case sym.downcase
          when 'a'..'z', '0'..'9'
            memo[i % 3] += (0xFF * ((i + 1).dlm_neighbor_slice) * DLM_ALLOWED.index(sym.downcase) / DLM_ALLOWED_SIZE).floor
          when /\p{L}/ # 'Letter'
          when /\p{M}/ # 'Mark'
          when /\p{N}/ # 'Number'
          when /\p{P}/ # 'Punctuation'
          when /\p{S}/ # 'Symbol'
          when /\p{Z}/ # 'Separator'
          when /\p{C}/ # 'Other'
          else
        end
        memo
      end.zip(DLM_FACTOR_RGB).map { |e| e.reduce(&:*) % 0xFF })
    end
    module_function :to_color
  end
end

class ::Numeric
  def dlm_neighbor_slice
    Bloomit::Numeric.dlm_neighbor_slice self
  end
end

class ::String
  def dlm_distance other
    Bloomit::String.dlm_distance self, other
  end
end

class ::Object
  def to_color **options
    Bloomit::String.to_color  case self
                                when ->(o) { o.respond_to?(:name) } then self.name
                                else self.to_s
                              end, options
  end
end
