<<-EXAMPLE
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
    @estimators = estimators
    @m = Array.new(estimators, 0)
    @numbits = Math.log2(estimators).to_i
  end  
  
  def add(element)
    estimator, n = assign(element)
    m[estimator] = [m[estimator], self.class.rho(n)].max
  end

  def cardinality
  end

  def rho(n)
    res = 0
    (1..numbits).each do |_|
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
    [h % estimators, h / estimators]
  end
  
  private

  attr_reader :estimators, :m, :numbits
end


<<-NOTES
Flip a coin forever, and keep track of your longest run of tails. That will estimate how long you've been flipping coints.

Flip 32 coints forever. Track runs of tails in the beginning of each of the 32 flips.

rho(x) = the position of the leftmost 1-bit in the binary string x



NOTES
