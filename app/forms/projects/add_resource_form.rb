# frozen_string_literal: true

module Projects
  class AddResourceForm < ApplicationForm
    attribute :amount, :float
    attribute :project_id
    attribute :subject_id
    attribute :subject_type

    validates :amount, presence: true
    validate :valid_subject_type?
    validate :valid_project
    validate :valid_resource, if: :resource_type?
    validate :valid_project_requirement, if: :check_project_requirement?

    def valid_subject_type?
      errors.add(:subject_type, :invalid) unless resource_type?
    end

    def valid_project
      errors.add(:project_id, :invalid) if project.blank? || different_location?
    end

    def valid_project_requirement
      errors.add(:project_id, :does_not_need_resource) if not_need_resource?
    end

    def check_project_requirement?
      errors.none?
    end

    def valid_resource
      errors.add(:subject_id, :invalid) if resource.blank? || not_in_inventory?
    end

    def project
      @project ||= Project.find_by(id: project_id)
    end

    def resource
      @resource ||= Resource.find_by(id: subject_id)
    end

    def inventory_object
      @inventory_object ||= character.inventory_objects.resource
                                     .find_by(subject_id: subject_id)
    end

    def project_description_object
      @project_description_object ||= project.project_descriptions
                                             .where(
                                               description_type: ProjectDescription::RESOURCE_IN,
                                               subject: resource
                                             ).first
    end

    private

    def resource_type?
      @resource_type ||= subject_type == 'Resource'
    end

    def different_location?
      project.location_id != character.location_id
    end

    def not_in_inventory?
      inventory_object.blank?
    end

    def not_need_resource?
      project_description_object.nil? ||
        project_description_object.amount == project_description_object.amount_needed
    end
  end
end
