# frozen_string_literal: true

module ActionView::Helpers::TranslationHelper
  delegate :td, :tn, to: I18n
end

module I18n
  def self.td(key, **options)
    t("#{key}.gen", **options.merge(default: [t(key), t("#{key}.n")]))
  end

  def self.tn(key, **options)
    t("#{key}.n", **options.merge(default: t(key)))
  end
end
