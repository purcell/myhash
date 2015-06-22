require 'hash_map'

class StringHashBenchmarks
  def run(n=5000)
    hash = HashMap.new
    input = random_strings(n)
    input.each do |s|
      hash[s] = s
    end
    stddev = stddev(hash.bucket_sizes)
    puts <<EOF
InputItems:  #{input.size}
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
