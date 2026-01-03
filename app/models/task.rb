class Task
  def initialize(name, due_date)
    @name = name
    @due_date = due_date
    @completed = false
  end

  def hash_complex(arr)
    arr
    a = Hash.new(0)
    [ "apple", "banana", "cherry", "vine", "date", "apple", "vine", "banana", "fig", "grape", "vine", "cherry" ].each do |word|
      a[word] += 1
    end

    result = Hash.new { |h, k| h[k] = [ ] }

    a.each do |item, count|
      result[count] << item
    end
  end

  #   ["apple", "banana", "cherry", "vine", "date", "apple", "vine", "banana", "fig", "grape", "vine", "cherry"]
  #   {2 => ["apple", "banana", "cherry"], 1 => ["date", "fig", "grape"], 3 => ["vine"]}
end
