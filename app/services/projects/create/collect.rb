# frozen_string_literal: true

module Projects
  class Create::Collect < Projects::Create::Base
    def call
      super

      create_project_descriptions!
    end

    private

    def project_attributes
      project_base_attributes.merge(
        {
          duration: duration,
          amount: amount,
          ready: true
        }
      )
    end

    def create_project_descriptions!
      @project.project_descriptions.create!(
        description_type: ProjectDescription::RESOURCE_OUT,
        subject: resource,
        amount: 0,
        amount_needed: amount,
        unit: resource.unit
      )
      return unless @params[:repeat]

      @project.project_descriptions.create!(
        description_type: ProjectDescription::REPEAT,
        subject: nil,
        amount: @params[:repeat],
        amount_needed: nil,
        unit: nil
      )
    end

    def project_info
      "#{type_name} #{resource_name}"
    end

    def type_name
      I18n.t("skills.#{resource.skill.key}")
    end

    def resource_name
      I18n.td("resources.#{resource.key}")
    end

    def duration
      (amount.to_f / resource.daily_rate) * GameTime::DAY
    end

    def amount
      @params[:amount].to_i
    end

    def resource
      @resource ||= location_resource.resource
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end
  end
end
