# frozen_string_literal: true

module Projects
  class Create::Machinery < Projects::Create::Base
    def call
      raise Projects::InvalidMachineError if machine.blank?
      raise Projects::RecipeNotFoundError if recipe.blank?

      @project = create_project!
      @events = []

      create_project_descriptions!

      create_creator_event!
      create_others_events!
      create_resource_events! if @events.any?
    end

    private

    def project_attributes
      project_base_attributes.merge(
        {
          duration: duration,
          amount: nil,
          ready: false,
          recipe: recipe
        }
      )
    end

    def duration
      ratio * GameTime::DAY
    end

    def project_info
      @project.short_name
    end

    def create_project_descriptions!
      # what to produce
      @project.project_descriptions.create!(
        description_type: ProjectDescription::RESOURCE_OUT,
        subject: resource_out,
        amount: amount,
        unit: 'grams'
      )
      # what to add:
      resources_in.each do |resource|
        description = @project.project_descriptions.create!(
          description_type: ProjectDescription::RESOURCE_IN,
          subject: resource[:resource],
          amount_needed: resource[:needed],
          amount: resource[:added],
          unit: 'grams'
        )
        @events << prepare_resource_event!(description) unless description.amount.zero?
      end
      # where to run
      @project.project_descriptions.create!(
        description_type: ProjectDescription::MACHINE,
        subject: machine
      )
    end

    def prepare_resource_event!(description)
      {
        amount: description.amount,
        resource: description.subject,
        project_name: @project.short_name,
        key: 'events.projects.machine.added_resource'
      }
    end

    def create_resource_events!
      @events.each do |event_params|
        InventoryObjects::DecreaseAmountService.call(
          @character, event_params[:resource], event_params[:amount]
        )

        event = Event.create!(
          body: I18n.t(
            event_params[:key],
            amount: event_params[:amount].to_i,
            resource: I18n.td("resources.#{event_params[:resource].key}"),
            project_name: event_params[:project_name]
          ),
          receiver_character: @character
        )

        Events::BroadcastService.call(@character, event)
      end
    end

    def amount
      @params[:amount]
    end

    def resources_in
      r_in = recipe.recipe_instructions.resource.map do |instruction|
        {
          resource: instruction.subject,
          needed: calculate_needed_amount(instruction),
          added: calculate_added_amount(instruction)
        }
      end
      return r_in unless r_in.any? { |r| r[:added].zero? } &&
                         @params[:resource_allocation] == 'full'

      r_in.each do |r|
        r[:added] = 0
      end

      r_in
    end

    def calculate_needed_amount(instruction)
      (instruction.amount * ratio).ceil
    end

    def calculate_added_amount(instruction)
      return 0 if @params[:resource_allocation] == 'none'

      inventory_object = @character.inventory_objects.resource.find_by(
        subject_id: instruction.subject_id
      )
      return 0 if inventory_object.blank?

      amount = calculate_needed_amount(instruction)

      if @params[:resource_allocation] == 'regardless'
        return inventory_object.amount if inventory_object.amount <= amount

      elsif inventory_object.amount < amount
        return 0

      end
      amount
    end

    def ratio
      @ratio ||= @params[:amount].to_f / instruction_out.amount
    end

    def resource_out
      instruction_out.subject
    end

    def instruction_out
      @instruction_out ||= recipe.recipe_instructions.resource_out.sole
    end

    def recipe
      Recipe.find_by(id: @params[:recipe_id])
    end

    def machine
      location.machines.find_by(id: @params[:machine_id])
    end
  end
end
