def init_array()
  # create and return array with 10 elements ( integer ) in it
  # DO NOT EDIT THIS FUNCTION
  x = [9, 7, 6, 5, 4, 6, 7, 1, 2, 3]
  x
end

def element_at(arr, index)
  # return the element of the Array variable `arr` at the position `index`
  # arr.at(index) # or
  # arr[index]
  arr[index]
end

def inclusive_range(arr, start_pos, end_pos)
  # return the elements of the Array variable `arr` between the start_pos and end_pos (both inclusive)
  arr[start_pos..end_pos]
end

def non_inclusive_range(arr, start_pos, end_pos)
  # return the elements of the Array variable `arr`, start_pos inclusive and end_pos exclusive
  arr[start_pos...end_pos]
end

def start_and_length(arr, start_pos, length)
  # return `length` elements of the Array variable `arr` starting from `start_pos`
  arr.slice(start_pos, length)
end

arr = init_array()

unless arr.is_a? Array
  puts "The variable returned from `init_array` is not an array"
  exit(0)
end

unless 10 == arr.length
  puts "Elements of the Array variable has to be exactly 10"
  exit(0)
else
  puts "Correct! Elements of the Array variable are 10 in number!"
end

unless arr.all? {|element| element.is_a? Integer}
  puts "All the elements of the Array initialized has to be integers"
  exit(0)
else
  puts "Correct! All the elements of the Array are Integers!"
end

ind = 8

val = element_at(arr, ind)

unless arr[ind] == element_at(arr, ind)
  x = val.to_s
  x = "nil" if val.nil?
  puts "Element at #{ind} returns #{x} is not #{arr[ind]}"
  exit(0)
else
  puts "Correct! Element at #{ind} is #{arr[ind]}!"
end

st = 4
en = 9

val = inclusive_range(arr, st, en)
unless arr[st..en] == val
  val = "nil" if val.nil?
  puts "The elements between the index #{st} and #{en} is #{arr[st..en]} and not #{val}"
  exit(0)
else
  puts "Correct! The elements between the index #{st} and #{en} is #{val}!"
end

st = 3
en = 8

val = non_inclusive_range(arr, st, en)
unless arr[st...en] == val
  val = "nil" if val.nil?
  puts "The elements between the index #{st} and #{en} (not included) is #{arr[st...en]} and not #{val}"
  exit(0)
else
  puts "Correct! The elements between the index #{st} and #{en} (not inclusive) is #{val}!"
end

st = 3
len = 6

val = start_and_length(arr, st, len)

unless arr[st, len] == val
  val = "nil" if val.nil?
  puts "The #{len} elements starting from #{st} are #{arr[st, len]} and not #{val}"
  exit(0)
else
  puts "Correct! The #{len} elements starting from #{st} are #{val}!"
end


def init_array()
  # create and return array with 10 elements ( integer ) in it
  x = [9, 7, 6, 5, 4, 6, 7, 1, 2, 3]
  x
end

def neg_pos(arr, index)
  # return the element of the array at the position `index` from the end of the list
  # Clue : arr[-index]
  arr[-index]
end

def first_element(arr)
  # return the first element of the array
  # arr.first
  arr.first
end

def last_element(arr)
  # return the last element of the array
  # arr.last
  arr.last
end

def first_n(arr, n)
  # return the first n elements of the array
  arr.first(n)
end

def drop_n(arr, n)
  # drop the first n elements of the array and return the rest
  arr.drop(n)
end


arr = init_array()

unless arr.is_a? Array
  puts "The variable returned from `init_array` is not an array"
  exit(0)
end

unless 10 == arr.length
  puts "Elements of the Array variable has to be exactly 10"
  exit(0)
else
  puts "Correct! Elements of the Array variable are 10 in number!"
end

unless arr.all? {|element| element.is_a? Integer}
  puts "All the elements of the Array initialized has to be integers"
  exit(0)
else
  puts "Correct! All the elements of the Array are Integers!"
end

neg_ind = 2
val = neg_pos(arr, neg_ind)
unless arr[-neg_ind] == val
  val = "nil" if val.nil?
  puts "The element at #{neg_ind} from the end of the array is not #{val}"
  exit(0)
else
  puts "Correct! The element at #{neg_ind} from the end of the array is #{val}"
end

val = first_element(arr)
unless arr.first == first_element(arr)
  val = "nil" if val.nil?
  puts "The first element of the array is not #{val}"
  exit(0)
else
  puts "Correct! The first element of the array is #{val}!"
end

val = last_element(arr)
unless arr.last == last_element(arr)
  val = "nil" if val.nil?
  puts "The last element of the array is not #{val}"
  exit(0)
else
  puts "Correct! The last element of the array is #{val}!"
end

len = 4
val = first_n(arr, len)
unless val == arr.take(len)
  val = "nil" if val.nil?
  puts "The first #{len} elements of the array are not #{val}"
  exit(0)
else
  puts "Correct! The first #{len} elements of the array are #{val}!"
end

len = 5
val = drop_n(arr, len)
unless val == arr.drop(len)
  val = "nil" if val.nil?
  puts "The elements of the array after dropping #{len} elements are not #{val}"
  exit(0)
else
  puts "Correct! The elements of the array after dropping #{len} elements are #{val}!"
end


def end_arr_add(arr, element)
  # Add `element` to the end of the Array variable `arr` and return `arr`
  arr.push(element)
end

def begin_arr_add(arr, element)
  # Add `element` to the beginning of the Array variable `arr` and return `arr`
  arr.unshift(element)
end

def index_arr_add(arr, index, element)
  # Add `element` at position `index` to the Array variable `arr` and return `arr`
  arr.insert(index, element)
end

def index_arr_multiple_add(arr, index)
  # add any two elements to the arr at the index
  arr.insert(index, 3, 2)
end

arr = Array.new

arr = end_arr_add(arr, 10)

if arr.nil?
  puts "Element #{10} has to be inserted into the array"
  exit(0)
end

unless 1 == arr.length
  puts "more than 1 element is inserted into the array"
  exit(0)
end

unless not arr.nil? and 10 == arr[0]
  puts "Element 10 is not inserted into the end of the array"
  exit(0)
else
  puts "Element 10 is inserted to the end of the array!"
end

arr = begin_arr_add(arr, 20)

unless not arr.nil? and 2 == arr.length and 20 == arr[0]
  puts "Element 20 is not inserted into the beginning of the array"
  exit(0)
else
  puts "Element 20 is inserted into the beginning of the array!"
end

arr = index_arr_add(arr, 1, 30)

unless not arr.nil? and 3 == arr.length and 30 == arr[1]
  puts "Element 30 is not inserted at the position #{1} of the array"
  exit(0)
else
  puts "Element 30 is inserted at the position #{1} of the array!"
end

index = 1
arr = index_arr_multiple_add(arr, index)

unless not arr.nil? and 5 == arr.length
  puts "Add two more elements to the array"
  exit(0)
else
  puts "Correct! You've added 2 elements to the array!"
end


def end_arr_delete(arr)
  # delete the element from the end of the array and return the deleted element
  arr.pop
end

def start_arr_delete(arr)
  # delete the element at the beginning of the array and return the deleted element
  arr.shift
end

def delete_at_arr(arr, index)
  # delete the element at the position #index
  arr.delete_at(index)
end

def delete_all(arr, val)
  # delete all the elements of the array where element = val
  arr.delete(val)
end


arr = [5, 4, 3, 2, "hello"]

val = end_arr_delete(arr)

unless not val.nil?
  puts "You have to returned the deleted element"
  exit(0)
end

unless "hello" == val
  puts "You have deleted #{val} instead of hello from the array"
  exit(0)
else
  puts "Correct! You have deleted the last element from the array"
end

arr = [5, 4, 3, 2]

val = start_arr_delete(arr)

unless not val.nil?
  puts "You have to returned the deleted element"
  exit(0)
end

unless 5 == val
  puts "You have deleted #{val} instead of 5 from the array"
  exit(0)
else
  puts "Correct! You have deleted the first element from the array"
end

arr = [3, 4, 5, 6, 1]

val = delete_at_arr(arr, 3)

unless not val.nil?
  puts "You have to returned the deleted element"
  exit(0)
end

unless 6 == val
  puts "You have deleted #{val} instead of 6 from the array"
  exit(0)
else
  puts "Correct! You have deleted the element at index #{3} from the array"
end

arr = [1, 2, 3, 4, 2, 2, 5]

val = delete_all(arr, 2)

unless not val.nil?
  puts "You have to returned the deleted element"
  exit(0)
end

unless 2 == val
  puts "You have deleted all occurrences #{val} instead of 2 from the array"
  exit(0)
else
  puts "Correct! You have deleted all occurrences of 2 from the array"
end

def select_arr(arr)
  # select and return all odd numbers from the Array variable `arr`
  arr.select(&:odd?)
end

def reject_arr(arr)
  # reject all elements which are divisible by 3
  arr.reject { |i| i % 3 == 0 }
end

def delete_arr(arr)
  # delete all negative elements
  arr.reject { |i| i < 0 }
end

def keep_arr(arr)
  # keep all non negative elements ( >= 0)
  arr.keep_if { |i| i >= 0}
end


arr = [3, 4, 2, 1, 2, 3, 4, 5, 6]

odd_elements = select_arr(arr)

unless odd_elements == arr.select {|a| a % 2 == 1}
  val = "nil" if val.nil?
  puts "You have to return only odd valued elements from the array."
  exit(0)
else
  puts "Correct! You have returned odd valued elements from the array!"
end

reject_div_3 = reject_arr(arr)

unless reject_div_3 == arr.reject {|a| a % 3 == 0}
  val = "nil" if val.nil?
  puts "You have to return all numbers that are not divisible by 3"
  exit(0)
else
  puts "Correct! You have returned all numbers that are divisible by 3!"
end

delete_neg = delete_arr(arr)

unless delete_neg == arr.delete_if {|a| a < 0}
  val = "nil" if val.nil?
  puts "You have to delete all the negative elements of the array"
  exit(0)
else
  puts "Correct! You have deleted all the negative elements of the array!"
end

keep_pos = keep_arr(arr)

unless keep_pos == arr.keep_if {|a| a > 0}
  val = "nil" if val.nil?
  puts "You have to retain all the positive elements of the array"
  exit(0)
else
  puts "Correct! You have retained all the positive elements of the array!"
end


# Initialize 3 variables here as explained in the problem statement
empty_hash = Hash.new
default_hash = Hash.new
default_hash.default = 1
hackerrank = Hash.new
hackerrank["simmy"] = 100
hackerrank["vivmbbs"] = 200


unless defined? empty_hash
  puts "variable named `empty_hash` is not defined"
  exit 0
else
  puts "variable named `empty_hash` is defined!"
end

unless empty_hash.is_a? Hash
  puts "`empty_hash` must belong to the class `Hash`"
  exit 0
else
  puts "`empty_hash` variable belongs to the class `Hash`!"
end

unless 0 == empty_hash.size
  puts "`empty_hash` must be of size 0"
  exit 0
else
  puts "`empty_hash` variable is of size 0!"
end

unless empty_hash.default.nil?
  puts "`empty_hash` default value is not nil"
  exit 0
else
  puts "`empty_hash` variable's default value is nil!"
end

unless defined? default_hash
  puts "variable named `default_hash` is not defined"
  exit 0
else
  puts "variable named `default_hash` is defined!"
end

unless default_hash.is_a? Hash
  puts "`default_hash` must belong the class `Hash`"
  exit 0
else
  puts "`default_hash` variable belongs to the class `Hash`!"
end

unless 0 == default_hash.size
  puts "`default_hash` must be of size 0"
  exit 0
else
  puts "`default_hash` variable is of size 0!"
end

unless 1 == default_hash.default
  puts "`default_hash`'s default value is not 1"
  exit 0
else
  puts "`default_hash`'s default value is 1!"
end

unless defined? hackerrank
  puts "`hackerrank` variable is not defined"
  exit 0
else
  puts "`hackerrank` variable is defined!"
end

unless hackerrank.is_a? Hash
  puts "`hackerrank` variable must belong to the class `Hash`"
  exit 0
else
  puts "`hackerrank` variable belongs to the class `Hash`!"
end

unless hackerrank.default.nil?
  puts "`hackerrank` variable's default value is not nil"
  exit 0
else
  puts "`hackerrank` variable's default value is nil!"
end

unless hackerrank.has_key? "simmy"
  puts "`hackerrank` has no key named `simmy`"
  exit 0
else
  puts "`hackerrank` has a key named `simmy`!"
end

unless 100 == hackerrank["simmy"]
  puts "hackerrank[\"simmy\"] value is not 100"
  exit 0
else
  puts "hackerrank[\"simmy\"] = 100!"
end

unless hackerrank.has_key? "vivmbbs"
  puts "`hackerrank` has no key named `vivmbbs`"
  exit 0
else
  puts "`hackerrank` has a key named `vivmbbs`!"
end

unless 200 == hackerrank["vivmbbs"]
  puts "hackerrank[\"vivmbbs\"] value is not 200"
  exit 0
else
  puts "hackerrank[\"vivmbbs\"] = 200!"
end

unless 2 == hackerrank.size
  puts "`hackerrank` key value pair size is not 2"
  exit 0
else
  puts "`hackerrank` key value pair size is 2!"
end


# Initialize 3 variables here as explained in the problem statement
empty_hash = Hash.new
default_hash = Hash.new
default_hash.default = 1
hackerrank = Hash.new
hackerrank["simmy"] = 100
hackerrank["vivmbbs"] = 200


unless defined? empty_hash
  puts "variable named `empty_hash` is not defined"
  exit 0
else
  puts "variable named `empty_hash` is defined!"
end

unless empty_hash.is_a? Hash
  puts "`empty_hash` must belong to the class `Hash`"
  exit 0
else
  puts "`empty_hash` variable belongs to the class `Hash`!"
end

unless 0 == empty_hash.size
  puts "`empty_hash` must be of size 0"
  exit 0
else
  puts "`empty_hash` variable is of size 0!"
end

unless empty_hash.default.nil?
  puts "`empty_hash` default value is not nil"
  exit 0
else
  puts "`empty_hash` variable's default value is nil!"
end

unless defined? default_hash
  puts "variable named `default_hash` is not defined"
  exit 0
else
  puts "variable named `default_hash` is defined!"
end

unless default_hash.is_a? Hash
  puts "`default_hash` must belong the class `Hash`"
  exit 0
else
  puts "`default_hash` variable belongs to the class `Hash`!"
end

unless 0 == default_hash.size
  puts "`default_hash` must be of size 0"
  exit 0
else
  puts "`default_hash` variable is of size 0!"
end

unless 1 == default_hash.default
  puts "`default_hash`'s default value is not 1"
  exit 0
else
  puts "`default_hash`'s default value is 1!"
end

unless defined? hackerrank
  puts "`hackerrank` variable is not defined"
  exit 0
else
  puts "`hackerrank` variable is defined!"
end

unless hackerrank.is_a? Hash
  puts "`hackerrank` variable must belong to the class `Hash`"
  exit 0
else
  puts "`hackerrank` variable belongs to the class `Hash`!"
end

unless hackerrank.default.nil?
  puts "`hackerrank` variable's default value is not nil"
  exit 0
else
  puts "`hackerrank` variable's default value is nil!"
end

unless hackerrank.has_key? "simmy"
  puts "`hackerrank` has no key named `simmy`"
  exit 0
else
  puts "`hackerrank` has a key named `simmy`!"
end

unless 100 == hackerrank["simmy"]
  puts "hackerrank[\"simmy\"] value is not 100"
  exit 0
else
  puts "hackerrank[\"simmy\"] = 100!"
end

unless hackerrank.has_key? "vivmbbs"
  puts "`hackerrank` has no key named `vivmbbs`"
  exit 0
else
  puts "`hackerrank` has a key named `vivmbbs`!"
end

unless 200 == hackerrank["vivmbbs"]
  puts "hackerrank[\"vivmbbs\"] value is not 200"
  exit 0
else
  puts "hackerrank[\"vivmbbs\"] = 200!"
end

unless 2 == hackerrank.size
  puts "`hackerrank` key value pair size is not 2"
  exit 0
else
  puts "`hackerrank` key value pair size is 2!"
end

def iter_hash(hash)
  hash.each do |key, value|
    puts key
    puts value
  end

  # your code here
end

hackerrank = Hash.new

(0..100).each do |id|
  hackerrank[id] = id * id + id
end

hackerrank["dheeraj"] = 100
hackerrank["shikhar"] = 200
hackerrank["abhiranjan"] = 300
hackerrank.store(543121, 100)
# Enter your code here.
hackerrank.keep_if { |key, value| key.is_a? Integer }
hackerrank.delete_if { |key, value| key.even? }


if hackerrank.has_key? 543121 and hackerrank[543121] = 100
  puts "Correct! You have added the key, value pair 543121, 100 to the Hash object `hackerrank`."
else
  puts "You have not added the key, value pair 543121, 100."
  exit(0)
end

if hackerrank.has_key?("dheeraj") or hackerrank.has_key?("shikhar") or hackerrank.has_key?("abhiranjan")
  puts "Non Integer keys are retained. You have to remove them."
  exit(0)
else
  puts "Correct! Only integer keys are retained."
end

hackerrank.keys.each do |id|
  if id % 2 == 0 and hackerrank.has_key? id
    puts "Even valued keys should be deleted"
    exit(0)
  end
end

puts "Correct! Even valued pairs are deleted."

def iterate_colors(colors)
  # Your code here
  colors.to_a
end



def rot13(secret_messages)
  # your code here
  secret_messages.map { |w| w.tr("a-z", "n-za-m") }
end


def rotate13(s)
  s.tr('A-Za-z', 'N-ZA-Mn-za-m')
end

def _rot13(secret_messages)
  secret_messages.map do |msg|
    rotate13(msg)
  end
end

msg = ['qrygn', 'zrrg ng pubpbyngr pbeare', 'gra zra', 'gjb onpxhc grnzf',
       'zvqavtug rkgenpgvba']

a1 = _rot13(msg)
t1 = rot13(msg)

unless t1.is_a? Array
  puts 'Your method must return an Array object.'
  exit(0)
end

unless t1.first.is_a? String
  puts 'The returned object must contain only strings.'
  exit(0)
end

unless a1.length == t1.length
  puts 'Oops! Are you sure you have decoded all the messages?'
  exit(0)
end

unless t1 == a1
  puts "Ah! Don't fail the mission my friend. Decode carefully!"
  exit(0)
end

puts 'Yay! You succesfully completeted the map challenge.'

""

def sum_terms(n)
  (0..n).inject do |sum, i|
    sum + i**2
  end
end


def fn(x)
  x*x + 1
end

def _sum_terms(n)
  1.upto(n).reduce(0) do |m, x|
    m + fn(x)
  end
end


num = gets.to_i
t1 = sum_terms(num)

t1 = sum_terms(num)
a1 = _sum_terms(num)

unless (t1.is_a? Fixnum or t1.is_a? Bignum)
  puts 'Your method must return an Integer (Fixnum, Bignum).'
  exit(0)
end

unless t1 == a1
  puts 'Ooops! Seems like you have done some mistake. Try again!'
  exit(0)
end

puts 'Kudos! Your have succesfully completed the challenge on reduce.'


def func_any(hash)
  # Check and return true if any key object within the hash is of the type Integer
  # If not found, return false.
  hash.keys.any? { |i| i.is_a? Integer }
end

def func_all(hash)
  # Check and return true if all the values within the hash are Integers and are < 10
  # If not all values satisfy this, return false.
  hash.values { |v| v.is_a?(Integer) && v < 10 }
end

def func_none(hash)
  # Check and return true if none of the values within the hash are nil
  # If any value contains nil, return false.
  hash.values.any? { |v| v.nil? }
end

def func_find(hash)
  # Check and return the first object that satisfies either of the following properties:
  #   1. There is a [key, value] pair where the key and value are both Integers and the value is < 20
  #   2. There is a [key, value] pair where the key and value are both Strings and the value starts with `a`.
  hash.find do |key, value|
    [key, value].any? { |i| i.is_a?(Integer) && i < 20} || ([key, value].any? { |i| i.is_a?(String) && value.start_with?("a")})
  end

end

####1. any? check for integer key in hash (true)
h = {"a" => "a", "b" => "b", "c" => 1, 1 => 2}
ans = func_any(h)
cor = h.any? {|key, value| key.is_a? Integer}

unless ans == cor
  puts "func_any: Wrong. There is a [key, value] pair in the Hash where the key is an Integer."
else
  puts "func_any: Correct! There is a [key, value] pair in the Hash where the key is an Integer."
end

####2. any? check for integer key in hash (false)
h = {"a" => "a", "b" => "b", "c" => 1}
ans = func_any(h)
cor = h.any? {|key, value| key.is_a? Integer}

unless ans == cor
  puts "func_any: Wrong. There is no [key, value] pair in the Hash where the key is an Integer."
else
  puts "func_any: Correct! There is no [key, value] pair in the Hash where the key is an Integer."
end

####3. all? check for integer value under 10 (true)
h = {"a" => 1, "c" => 2, "d" => 3, "e" => 9}
cor = h.all? {|key, value| (value.is_a? Integer and value < 10) }
ans = func_all(h)
unless ans == cor
  puts "func_all: Wrong. All [key, value] pairs in the Hash have a value that is an Integers < 10."
else
  puts "func_all: Correct! All [key, value] pairs in the Hash have a value that is an Integer < 10."
end

####4. all? check for integer value under 10 (false)
h = {"a" => 10, "c" => 20, "d" => 30, "e" => 1}
cor = h.all? {|key, value| (value.is_a? Integer and value < 10) }
ans = func_all(h)
unless ans == cor
  puts "func_all: Wrong. Not all [key, value] pairs in the Hash have a value that's an Integer < 10."
else
  puts "func_all: Correct! Not all [key, value] pairs in the Hash have a value that's an Integer < 10."
end


####5. none? check for no nil value (true)
h = {"a" => 1, "b" => 2, "c" => 3, "d" => 1}
cor = h.none? {|key, value| value.nil?}

ans = func_none(h)

unless ans == cor
  puts "func_none: Wrong. There is no [key, value] pair in the Hash where the value is nil."
else
  puts "func_none: Correct! There is no [key, value] pair in the Hash where the value is nil."
end

####6. none? check for no nil value (true)
h = {"a" => 1, "b" => 2, "c" => 3, "d" => nil}
cor = h.none? {|key, value| value.nil?}

ans = func_none(h)

unless ans == cor
  puts "func_none: Wrong. There is a [key, value] pair in the Hash where the value is nil."
else
  puts "func_none: Correct! There is a [key, value] pair in the Hash where the value is nil."
end


####7. func_find first condition check

h = {"a" => "b", "b" => "c", 1 => 2}
cor = h.find {|key, value| (key.is_a? Integer and value.is_a? Integer and value < 20) or (key.is_a? String and value.is_a? String and value.start_with? "a")}

ans = func_find(h)
# cor = [1, 2]

unless ans == cor
  puts "func_find: Wrong. There is a [key, value] pair in the Hash that satisfies one of the properties."
else
  puts "func_find: Correct! There is a [key, value] pair in the Hash that satisfies one of the properties."
end

####7. func_find first condition check 2 (fail)

h = {2 => 40, 3 => 60, 1 => 20}
cor = h.find {|key, value| (key.is_a? Integer and value.is_a? Integer and value < 20) or (key.is_a? String and value.is_a? String and value.start_with? "a")}

ans = func_find(h)
# cor = [1, 2]

unless ans == cor
  puts "func_find: Wrong. There is no [key, value] pair in the Hash that satisfies one of the properties."
else
  puts "func_find: Correct! There is no [key, value] pair in the Hash that satisfies one of the properties."
end

####8. func_find second condition check

h = {"a" => 22, "b" => 21, "c" => "abc"}
cor = h.find {|key, value| (key.is_a? Integer and value.is_a? Integer and value < 20) or (key.is_a? String and value.is_a? String and value.start_with? "a")}

ans = func_find(h)
# cor = ["c", "abc"]

unless ans == cor
  puts "func_find: Wrong. There is a [key, value] pair in the Hash that satisfies one of the properties."
else
  puts "func_find: Correct! There is a [key, value] pair in the Hash that satisfies one of the properties."
end

####9. func_find none satisfy

h = {"a" => "b", "b" => "c", "c" => "d", 1 => "a"}
cor = h.find {|key, value| (key.is_a? Integer and value.is_a? Integer and value < 20) or (key.is_a? String and value.is_a? String and value.start_with? "a")}

ans = func_find(h)
# cor = nil

unless ans == cor
  puts "func_find: Wrong. There is no [key, value] pair in the Hash that satisfies either property."
else
  puts "func_find: Correct! There is no [key, value] pair in the Hash that satisfies either property."
end

def group_by_marks(marks, pass_marks)
  # your code here
  marks.group_by {
    |key, value| value < pass_marks ? "Failed" : "Passed"
  }
end

def _group_by_marks(marks, n)
  marks.group_by do |key, value|
    if value < n
      'Failed'
    else
      'Passed'
    end
  end
end

marks = {"Ramesh" => 23, "Vivek" => 40, "Harsh" => 88, "Mohammad" => 60}

n = gets.to_i
t1 = group_by_marks(marks, n)
a1 = _group_by_marks(marks, n)

unless t1.is_a? Hash
  puts 'Watch out! Your method must return a Hash.'
end

unless t1 == a1
  puts 'Ooops! Seems like you missed something in output.'
  exit(0)
end

puts 'Cool! You have completed the group_by challenge!'


def take(array, n)
  array.drop(n)
end


unless Object.respond_to?(:take, true)
  puts 'You must define the method first!'
  exit(0)
end

a1 = take([-4, 5, 9, 0], 4) == []
a2 = take(['a', 'b', 56, /d+/], 1) == ['b', 56, /d+/]
a3 = take([121, 35, 523, 898], 0) == [121, 35, 523, 898]

unless [a1, a2, a3].all?
  puts 'So close! Please recheck your output!'
  exit(0)
end

puts 'Yay! You have successfully completed your challenge!'


def full_name(*names)
  names.join(" ")
end

