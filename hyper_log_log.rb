<<-EXAMPLE
Based on Youtube video of "Ben Linsay on HyperLogLog [PWL NYC]"

# random stream:

n = 3 #...something...
r = Random.new
stream = (1..10**9).lazy.map{|_| r.rand(n) }
Set.new(stream).length
# ... after a very long time ... returns
# > n
EXAMPLE

require 'digest/sha1'

class HyperLogLog
  def initialize(estimators)
    #estimators should be a power of 2!!!    
    @n = estimators
    @m = Array.new(n, 0)
    @numbits = Math.log2(n).to_i
  end  

  def self.estimate_biases
    (4..12).each do |n|
      hnn = new(2**n)
      (1..1000000).each {|x| hnn.add(x)}
      puts "#{n}    | #{2**n}   |  #{hnn.cardinality / 1000000}"
    end
  end
  
  def add(element)
    estimator, n = assign(element)
    m[estimator] = [m[estimator], rho(n)].max
  end

  def cardinality
    n * self.class.harmonic_mean(m.map{|x| 2**x})
  end

  def self.bias_correction(n)
    # also called alpha in the wikipedia article
    return 0.673 if n <= 16
    return 0.697 if n <= 32
    return 0.709 if n <= 64
    return 0.715 if n <= 128
    0.7213/(1+1.079/n)
  end
  
  def self.harmonic_mean(nums)
    # puts "harmonic_mean(#{nums})"
    nums.length / nums.inject(0.0){|sum, x| sum + 1/x.to_f}
  end
  
  def rho(n)
    res = 0
    (1..(160-numbits)).each do |_|
      return res if n & 1 == 1
      res += 1
      n = n >> 1
    end
    res
  end
  
  def self.hash(x)
    #160-bit integer
    Digest::SHA1.hexdigest(x.to_s).to_i(16)
  end

  def assign(x)
    h = self.class.hash(x)
    [h % n, h / n]
  end
  
  private

  attr_reader :n, :m, :numbits
end


<<-NOTES
Flip a coin forever, and keep track of your longest run of tails. That will estimate how long you've been flipping coints.

Flip 32 coints forever. Track runs of tails in the beginning of each of the 32 flips.

rho(x) = the position of the leftmost 1-bit in the binary string x



NOTES
