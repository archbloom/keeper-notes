#
# Class for Tagging the Notes
#   field name - required, should be unique
#
class Tag < ApplicationRecord
  has_and_belongs_to_many :notes

  validates :name, presence: true, uniqueness: true

  before_validation do
    self.name = self.name.downcase
  end
end
