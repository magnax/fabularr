# frozen_string_literal: true

module Projects
  class Create::CreateLocation < Projects::Create::Base
    private

    def project_attributes
      project_base_attributes.merge(
        {
          duration: project_type.base_speed,
          amount: nil,
          ready: true
        }
      )
    end

    def project_info
      I18n.t("project_types.#{project_type.key}")
    end
  end
end
