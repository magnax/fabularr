# frozen_string_literal: true

module ActionView::Helpers::TranslationHelper
  def td(key, **options)
    t("#{key}.gen", **options.merge(default: [t(key), t("#{key}.n")]))
  end

  def tn(key, **options)
    t("#{key}.n", **options.merge(default: t(key)))
  end
end
