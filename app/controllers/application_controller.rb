class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Enable CSRF protection with support for both HTML forms and JSON/API requests
  # CSRF tokens can be sent via:
  # - Form parameter: authenticity_token (for HTML forms)
  # - HTTP header: X-CSRF-Token (for JSON/API requests)
  protect_from_forgery with: :exception

  # Helper method to get CSRF token for API clients
  def csrf_token
    form_authenticity_token
  end
end
