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

    sanitized_query = sanitize_sql_array([ "plainto_tsquery('english', ?)", query ])
    rank_sql = "ts_rank(search_vector, #{sanitized_query}) DESC"

    # Combine full-text search with ILIKE for stop words
    # Full-text search handles normal words, ILIKE handles stop words and short queries
    fulltext_condition = "search_vector @@ #{sanitized_query}"
    like_condition = "body ILIKE ?"
    like_value = "%#{sanitize_sql_like(query)}%"

    where("(#{fulltext_condition}) OR (#{like_condition})", like_value)
      .order(Arel.sql(rank_sql))
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

    # Build full-text query with OR
    query = words.compact.join(" | ")
    sanitized_query = sanitize_sql_array([ "plainto_tsquery('english', ?)", query ])
    rank_sql = "ts_rank(search_vector, #{sanitized_query}) DESC"

    # Build ILIKE conditions for each word (handles stop words)
    like_conditions = words.compact.map { "body ILIKE ?" }.join(" OR ")
    like_values = words.compact.map { |word| "%#{sanitize_sql_like(word)}%" }

    # Combine: full-text search OR any of the ILIKE conditions
    fulltext_condition = "search_vector @@ #{sanitized_query}"
    where("(#{fulltext_condition}) OR (#{like_conditions})", *like_values)
      .order(Arel.sql(rank_sql))
  }

  # Case-insensitive LIKE search (fallback, less performant)
  scope :search_like, ->(term) {
    return all if term.blank?

    where("body ILIKE ?", "%#{sanitize_sql_like(term)}%")
  }
end
