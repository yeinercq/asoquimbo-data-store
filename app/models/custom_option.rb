class CustomOption < ApplicationRecord
  belongs_to :custom_option_list

  validates :name, presence: true

  scope :ordered, -> { order(id: :asc) }
end
