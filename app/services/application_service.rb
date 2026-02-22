# frozen_string_literal: true

class ApplicationService
  private_class_method :new

  def self.call(...)
    new(...).call
  end
end
