require 'hash_map'

class StringHashBenchmarks
  def run
    hash = HashMap.new
    input = random_strings
    input.each do |s|
      hash[s] = s
    end
    avg, stddev = avg_and_stddev(hash.bucket_sizes)
    puts "InputItems: #{input.size}"
    puts "HashedItems: #{hash.size}"
    puts "Buckets: #{hash.bucket_sizes.size}"
    puts "LoadFactor: #{hash.load_factor}"
    puts "Avg: #{avg}"
    puts "Stddev: #{stddev}"
  end

  def avg_and_stddev(nums)
    avg = nums.inject(:+).to_f / nums.size
    stddev = (nums.inject(0) { |total, s| total + (s - avg) ** 2 }) / nums.size
    [avg, stddev]
  end

  def random_strings
    File.read('/usr/share/dict/words').each_line.to_a.sample(30000)
  end
end
