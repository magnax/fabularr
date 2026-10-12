# frozen_string_literal: true

module Notes::SanitizeInputHelper
  def sanitize_title(title)
    sanitizer.sanitize(title, tags: [])
  end

  def sanitize_body(body)
    sanitizer.sanitize(body, tags: %w[b i strong], scrubber: scrubber)
  end

  def scrubber
    Loofah::Scrubber.new do |node|
      node.remove if node.name == 'script'
    end
  end

  def sanitizer
    @sanitizer ||= Rails::HTML5::SafeListSanitizer.new
  end
end
