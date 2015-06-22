require 'ruby-prof'
require 'hash_map'

class StringHashBenchmarks
  def initialize(n=5000)
    @input = random_strings(n)
  end

  def run
    hash = HashMap.new
    @input.each do |s|
      hash[s] = s
    end
    stddev = stddev(hash.bucket_sizes)
    puts <<EOF
InputItems:  #{@input.size}
HashedItems: #{hash.size}
Buckets:     #{hash.bucket_sizes.size}
LoadFactor:  #{hash.load_factor}
Stddev:      #{stddev}
EOF
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

def string_hash_benchmark(n=5000)
  StringHashBenchmarks.new(n).run
end

def string_hash_profile(n=5000)
  benchmark = StringHashBenchmarks.new(n)
  result = RubyProf.profile do
    benchmark.run
  end
  printer = RubyProf::GraphHtmlPrinter.new(result)
  fname = "/tmp/profile.html"
  File.open(fname, 'w') do |f|
    printer.print(f)
  end
  system("open '#{fname}'")
end
