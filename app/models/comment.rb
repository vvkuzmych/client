# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  archived      :boolean          default(FALSE), not null
#  body          :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  issue_id      :bigint           not null
#  search_vector :tsvector
#  user_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_archived          (archived)
#  index_comments_on_issue_id          (issue_id)
#  index_comments_on_search_vector     (search_vector) USING gin
#  index_comments_on_user_id           (user_id)
#  ix_comments_issue_created           (issue_id,created_at,id)
#  ix_comments_issue_user_created      (issue_id,user_id,created_at,id)
#  ix_comments_user_created            (user_id,created_at,id)
#
# Foreign Keys
#
#  fk_rails_...  (issue_id => issues.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  # Validations
  validates :body, presence: true

  # Associations
  belongs_to :issue
  belongs_to :user

  # Scopes
  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }

  # Full-text search scopes
  # Search for a word or phrase in the body
  # Uses both full-text search and ILIKE to handle stop words and short queries
  scope :search, ->(query) {
    return all if query.blank?

    # Use parameterized queries to avoid SQL injection
    fulltext_query = where(sanitize_sql_array([ "search_vector @@ plainto_tsquery('english', ?)", query ]))
    like_query = where("body ILIKE ?", "%#{sanitize_sql_like(query)}%")
    rank_sql = sanitize_sql_array([ "ts_rank(search_vector, plainto_tsquery('english', ?)) DESC", query ])

    # Combine queries using 'or' (Brakeman-safe, no string interpolation)
    fulltext_query.or(like_query).order(Arel.sql(rank_sql))
  }

  # Search with exact phrase matching
  scope :search_phrase, ->(phrase) {
    return all if phrase.blank?

    sanitized_phrase = sanitize_sql_array([ "phraseto_tsquery('english', ?)", phrase ])
    rank_sql = "ts_rank(search_vector, #{sanitized_phrase}) DESC"
    where("search_vector @@ #{sanitized_phrase}")
      .order(Arel.sql(rank_sql))
  }

  # Search multiple words (AND - all words must be present)
  scope :search_all_words, ->(*words) {
    return all if words.compact.blank?

    query = words.compact.join(" & ")
    search(query)
  }

  # Search multiple words (OR - any word can be present)
  # Combines full-text search with ILIKE to handle stop words
  scope :search_any_word, ->(*words) {
    return all if words.compact.blank?

    clean_words = words.compact
    query = clean_words.join(" | ")

    # Build full-text search query
    fulltext_query = where(sanitize_sql_array([ "search_vector @@ plainto_tsquery('english', ?)", query ]))
    rank_sql = sanitize_sql_array([ "ts_rank(search_vector, plainto_tsquery('english', ?)) DESC", query ])

    # Build ILIKE query for each word (handles stop words)
    like_queries = clean_words.map do |word|
      where("body ILIKE ?", "%#{sanitize_sql_like(word)}%")
    end

    # Combine: full-text search OR any ILIKE query
    # Use 'or' to combine queries safely (Brakeman-safe)
    combined = like_queries.reduce(fulltext_query) { |acc, q| acc.or(q) }
    combined.order(Arel.sql(rank_sql))
  }

  # Case-insensitive LIKE search (fallback, less performant)
  scope :search_like, ->(term) {
    return all if term.blank?

    where("body ILIKE ?", "%#{sanitize_sql_like(term)}%")
  }
end
