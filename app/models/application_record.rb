# frozen_string_literal: true

# Parent class for every custom model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
