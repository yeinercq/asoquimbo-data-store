# == Schema Information
#
# Table name: custom_options
#
#  id                    :bigint           not null, primary key
#  custom_option_list_id :bigint           not null
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class CustomOption < ApplicationRecord
  belongs_to :custom_option_list

  validates :name, presence: true

  scope :ordered, -> { order(id: :asc) }
end
