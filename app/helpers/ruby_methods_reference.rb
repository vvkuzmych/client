# Ruby Methods Reference Guide
# This file contains examples of commonly used Ruby methods for quick reference
# These methods can be used in Rails helpers, models, controllers, and views

# ============================================================================
# STRING METHODS
# ============================================================================

# 1. capitalize - Capitalizes the first letter
"hello world".capitalize  # => "Hello world"

# 2. upcase - Converts to uppercase
"hello".upcase  # => "HELLO"

# 3. downcase - Converts to lowercase
"HELLO".downcase  # => "hello"

# 4. strip - Removes leading and trailing whitespace
"  hello  ".strip  # => "hello"

# 5. split - Splits string into array
"hello,world,test".split(",")  # => ["hello", "world", "test"]

# 6. gsub - Global substitution
"hello world".gsub("world", "ruby")  # => "hello ruby"

# 7. include? - Checks if string contains substring
"hello world".include?("world")  # => true

# 8. start_with? - Checks if string starts with prefix
"hello".start_with?("he")  # => true

# 9. end_with? - Checks if string ends with suffix
"hello".end_with?("lo")  # => true

# 10. length / size - Returns string length
"hello".length  # => 5
"hello".size    # => 5

# 11. reverse - Reverses the string
"hello".reverse  # => "olleh"

# 12. empty? - Checks if string is empty
"".empty?  # => true
"hello".empty?  # => false

# 13. blank? - Rails method: checks if nil, empty, or whitespace only
"".blank?  # => true
"  ".blank?  # => true

# 14. present? - Rails method: opposite of blank?
"hello".present?  # => true

# ============================================================================
# ARRAY METHODS
# ============================================================================

# 15. map / collect - Transforms each element
[ 1, 2, 3 ].map { |x| x * 2 }  # => [ 2, 4, 6 ]

# 16. select / find_all - Filters elements matching condition
[ 1, 2, 3, 4 ].select { |x| x.even? }  # => [ 2, 4 ]

# 17. reject - Filters elements NOT matching condition
[ 1, 2, 3, 4 ].reject { |x| x.even? }  # => [ 1, 3 ]

# 18. find / detect - Finds first element matching condition
[ 1, 2, 3, 4 ].find { |x| x > 2 }  # => 3

# 19. any? - Checks if any element matches
[ 1, 2, 3 ].any? { |x| x > 2 }  # => true

# 20. all? - Checks if all elements match
[ 1, 2, 3 ].all? { |x| x > 0 }  # => true

# 21. empty? - Checks if array is empty
[].empty?  # => true

# 22. first - Gets first element
[ 1, 2, 3 ].first  # => 1

# 23. last - Gets last element
[ 1, 2, 3 ].last  # => 3

# 24. include? - Checks if array includes element
[ 1, 2, 3 ].include?(2)  # => true

# 25. join - Joins array elements into string
[ 1, 2, 3 ].join(", ")  # => "1, 2, 3"

# 26. compact - Removes nil elements
[ 1, nil, 2, nil ].compact  # => [ 1, 2 ]

# 27. uniq - Returns unique elements
[ 1, 2, 2, 3 ].uniq  # => [ 1, 2, 3 ]

# 28. sort - Sorts array
[ 3, 1, 2 ].sort  # => [ 1, 2, 3 ]

# 29. reverse - Reverses array
[ 1, 2, 3 ].reverse  # => [ 3, 2, 1 ]

# 30. sum - Sums numeric elements
[ 1, 2, 3 ].sum  # => 6

# ============================================================================
# HASH METHODS
# ============================================================================

# 31. keys - Returns array of keys
{ a: 1, b: 2 }.keys  # => [:a, :b]

# 32. values - Returns array of values
{ a: 1, b: 2 }.values  # => [1, 2]

# 33. has_key? / key? - Checks if key exists
{ a: 1 }.has_key?(:a)  # => true

# 34. has_value? / value? - Checks if value exists
{ a: 1 }.has_value?(1)  # => true

# 35. merge - Merges two hashes
{ a: 1 }.merge({ b: 2 })  # => { a: 1, b: 2 }

# 36. fetch - Gets value with optional default
{ a: 1 }.fetch(:a, "default")  # => 1
{ a: 1 }.fetch(:b, "default")  # => "default"

# ============================================================================
# NUMBER METHODS
# ============================================================================

# 37. times - Executes block n times
5.times { |i| puts i }  # => 0, 1, 2, 3, 4

# 38. upto - Iterates from number to limit
1.upto(5) { |i| puts i }  # => 1, 2, 3, 4, 5

# 39. downto - Iterates from number down to limit
5.downto(1) { |i| puts i }  # => 5, 4, 3, 2, 1

# 40. abs - Absolute value
(-5).abs  # => 5

# 41. round - Rounds to nearest integer
3.7.round  # => 4

# 42. ceil - Rounds up
3.2.ceil  # => 4

# 43. floor - Rounds down
3.8.floor  # => 3

# ============================================================================
# DATE/TIME METHODS
# ============================================================================

# 44. Time.current - Rails: current time with timezone
Time.current  # => 2025-01-07 10:30:00 +0200

# 45. Date.today - Current date
Date.today  # => #<Date: 2025-01-07>

# 46. strftime - Format date/time
Time.current.strftime("%Y-%m-%d")  # => "2025-01-07"

# ============================================================================
# RAILS ACTIVE SUPPORT METHODS
# ============================================================================

# 47. pluralize - Rails helper: pluralizes word
1.pluralize("user")  # => "user"
2.pluralize("user")  # => "users"

# 48. truncate - Rails helper: truncates text
"Hello world".truncate(5)  # => "He..."

# 49. humanize - Rails: makes string human-readable
"user_name".humanize  # => "User name"

# 50. titleize - Rails: title case
"hello world".titleize  # => "Hello World"

# ============================================================================
# USAGE EXAMPLES IN RAILS CONTEXT
# ============================================================================

# Example 1: String manipulation in helpers
def format_name(name)
  name.strip.titleize
end

# Example 2: Array filtering in models
def active_users
  users.select { |u| u.active? }
end

# Example 3: Hash operations in controllers
def filter_params(params)
  params.slice(:name, :email).compact
end

# Example 4: Date formatting in views
def formatted_date(date)
  date.strftime("%B %d, %Y")
end

# Example 5: Conditional checks
def display_message(items)
  if items.any? { |item| item.published? }
    "You have published items"
  else
    "No published items"
  end
end

# Example 6: Chaining methods
def process_text(text)
  text.strip.downcase.titleize
end

# Example 7: Safe navigation (Rails 5+)
user&.email&.upcase  # => nil if user or email is nil

# Example 8: Presence checking
def get_name(user)
  user.name.presence || "Anonymous"
end

# Example 9: Array operations
def get_ids(collection)
  collection.map(&:id).uniq.sort
end

# Example 10: Hash with default values
def get_config(key)
  settings.fetch(key, "default_value")
end

# ============================================================================
# TIPS AND BEST PRACTICES
# ============================================================================

# 1. Use safe navigation operator (&.) to avoid nil errors
#    user&.profile&.name

# 2. Use present? instead of !blank? for readability
#    name.present?

# 3. Chain methods for cleaner code
#    text.strip.downcase.titleize

# 4. Use blocks with enumerable methods
#    items.select { |item| item.active? }

# 5. Prefer symbol syntax for hash keys in Rails
#    { name: "John", age: 30 }

# 6. Use compact to remove nils from arrays
#    [ 1, nil, 2 ].compact  # => [ 1, 2 ]

# 7. Use fetch for hash access with defaults
#    hash.fetch(:key, "default")

# 8. Use blank? to check for empty/nil values
#    value.blank?  # checks nil, empty, or whitespace

# 9. Use presence for conditional assignments
#    name.presence || "Default"

# 10. Use map(&:method) for simple transformations
#     users.map(&:name)  # => ["John", "Jane"]
