module UtilityHelper
  # String helpers
  def truncate_text(text, length = 100, omission = "...")
    return "" if text.blank?
    text.to_s.truncate(length, omission: omission)
  end

  def pluralize_word(count, singular, plural = nil)
    count.to_i == 1 ? singular : (plural || "#{singular}s")
  end

  def format_currency(amount, currency = "USD")
    number_to_currency(amount, unit: currency == "USD" ? "$" : currency, precision: 2)
  end

  def format_percentage(value, precision = 1)
    number_to_percentage(value, precision: precision)
  end

  def format_number(number, precision = 0)
    number_with_delimiter(number, delimiter: ",", separator: ".")
  end

  def strip_html(html_string)
    ActionController::Base.helpers.strip_tags(html_string).strip
  end

  def highlight_text(text, term)
    highlight(text, term, highlighter: '<mark>\1</mark>') if term.present?
  end

  # Date/Time helpers
  def format_date(date, format = :long)
    return "" if date.blank?
    I18n.l(date.to_date, format: format)
  end

  def format_datetime(datetime, format = :long)
    return "" if datetime.blank?
    I18n.l(datetime, format: format)
  end

  def time_ago_in_words_custom(date)
    return "" if date.blank?
    distance_of_time_in_words(date, Time.current)
  end

  def format_date_short(date)
    date&.strftime("%b %d, %Y")
  end

  def format_time_only(datetime)
    datetime&.strftime("%I:%M %p")
  end

  # Status helpers
  def status_badge(status, type: "secondary")
    content_tag(:span, status.to_s.humanize, class: "badge bg-#{type}")
  end

  def status_label(status)
    case status.to_s.downcase
    when "open", "active", "approved"
      status_badge(status, type: "success")
    when "closed", "archived", "rejected"
      status_badge(status, type: "danger")
    when "pending", "draft", "review"
      status_badge(status, type: "warning")
    else
      status_badge(status)
    end
  end

  def boolean_badge(value)
    value ? status_badge("Yes", type: "success") : status_badge("No", type: "secondary")
  end

  # Link helpers
  def external_link(url, text = nil, options = {})
    text ||= url
    link_to text, url, options.merge(target: "_blank", rel: "noopener noreferrer")
  end

  def mailto_link(email, text = nil, options = {})
    text ||= email
    link_to text, "mailto:#{email}", options
  end

  def safe_link(url, text = nil, options = {})
    return "" if url.blank?
    link_to(text || url, url, options)
  end

  # Form helpers
  def form_group(field_name, form, &block)
    content_tag(:div, class: "form-group") do
      form.label(field_name, class: "form-label") +
        capture(&block) +
        (form.object.errors[field_name].any? ? content_tag(:div, form.object.errors[field_name].join(", "), class: "text-danger") : "")
    end
  end

  def required_field
    content_tag(:span, "*", class: "text-danger")
  end

  # Display helpers
  def empty_state(message = "No items found", icon: nil)
    content_tag(:div, class: "empty-state text-center py-5") do
      (icon ? content_tag(:i, "", class: "icon #{icon}") : "") +
        content_tag(:p, message, class: "text-muted")
    end
  end

  def loading_spinner(text = "Loading...")
    content_tag(:div, class: "loading-spinner text-center") do
      content_tag(:div, class: "spinner-border", role: "status") do
        content_tag(:span, text, class: "visually-hidden")
      end
    end
  end

  def tooltip(text, tooltip_text)
    content_tag(:span, text, title: tooltip_text, data: { bs_toggle: "tooltip" }, class: "text-muted")
  end

  def copy_to_clipboard(text, button_text = "Copy")
    content_tag(:button, button_text, class: "btn btn-sm btn-outline-secondary", data: { clipboard_text: text }, onclick: "navigator.clipboard.writeText('#{text}')")
  end

  # Array/Collection helpers
  def list_items(items, separator = ", ")
    items.reject(&:blank?).join(separator)
  end

  def pagination_info(collection)
    return "" if collection.blank?
    "Showing #{collection.offset_value + 1} to #{[ collection.offset_value + collection.limit_value, collection.total_count ].min} of #{collection.total_count}"
  end

  # Security helpers
  def sanitize_html(html)
    sanitize(html, tags: %w[p br strong em ul ol li a], attributes: %w[href class])
  end

  def csrf_meta_tag_content
    csrf_meta_tags
  end

  # URL helpers
  def current_url_with_params(params_to_add)
    url_for(request.query_parameters.merge(params_to_add))
  end

  def url_with_protocol(url)
    return url if url.blank? || url.match?(/^https?:\/\//)
    "https://#{url}"
  end

  # Format helpers
  def format_file_size(bytes)
    return "0 Bytes" if bytes.zero?
    units = %w[Bytes KB MB GB TB]
    size = bytes.to_f
    unit_index = (Math.log(size) / Math.log(1024)).floor
    unit_index = [ unit_index, units.length - 1 ].min
    "#{(size / (1024**unit_index)).round(2)} #{units[unit_index]}"
  end

  def format_duration(seconds)
    return "0s" if seconds.zero?
    hours = (seconds / 3600).floor
    minutes = ((seconds % 3600) / 60).floor
    secs = seconds % 60
    parts = []
    parts << "#{hours}h" if hours > 0
    parts << "#{minutes}m" if minutes > 0
    parts << "#{secs}s" if secs > 0
    parts.join(" ")
  end

  # Validation helpers
  def has_errors?(object, field)
    object.errors[field].any?
  end

  def error_message(object, field)
    object.errors[field].first
  end

  def field_has_errors?(form, field)
    form.object.errors[field].any?
  end

  # Conditional helpers
  def if_blank(value, default = "")
    value.blank? ? default : value
  end

  def presence_or_default(value, default = "N/A")
    value.presence || default
  end

  # Color helpers
  def color_from_string(str, saturation: 50, lightness: 50)
    hash = str.hash.abs
    hue = hash % 360
    "hsl(#{hue}, #{saturation}%, #{lightness}%)"
  end

  def priority_color(priority)
    case priority
    when 1 then "danger"
    when 2 then "warning"
    when 3 then "info"
    when 4, 5 then "success"
    else "secondary"
    end
  end
end
