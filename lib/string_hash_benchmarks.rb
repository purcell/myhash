require 'benchmark'
require 'ruby-prof'
require 'hash_map'

module Measurements
  def benchmark(meth)
    times = Benchmark.measure(&method(meth))
    Array(@after).each(&:call)
    puts "Times:     #{times}"
  end

  def profile(meth)
    result = RubyProf.profile do
      send(meth)
    end
    Array(@after).each(&:call)
    printer = RubyProf::GraphHtmlPrinter.new(result)
    fname = "/tmp/profile.html"
    File.open(fname, 'w') do |f|
      printer.print(f)
    end
    system("open '#{fname}'")
  end

  def after(&block)
    (@after ||= []) << block
  end
end

class StringHashBenchmarks
  include Measurements

  def initialize(n=5000)
    @input = random_strings(n)
  end

  def run_hashing
    @input.each do |s| s.myhash end
  end

  def run_insert
    hash = HashMap.new
    @input.each do |s|
      hash[s] = s
    end
    after do
      stddev = stddev(hash.bucket_sizes)
      empty = hash.bucket_sizes.count(0)
      puts <<EOF
InputItems:  #{@input.size}
HashedItems: #{hash.size}
Buckets:     #{hash.bucket_sizes.size}
Empty:       #{empty}
LoadFactor:  #{hash.load_factor}
Stddev:      #{stddev}
EOF
    end
  end

  def stddev(nums)
    avg = nums.inject(:+).to_f / nums.size
    (nums.inject(0) { |total, s| total + (s - avg) ** 2 }) / nums.size
  end

  def random_strings(n)
    srand(1)
    File.read('/usr/share/dict/words').each_line.to_a.sample(n)
  end
end



