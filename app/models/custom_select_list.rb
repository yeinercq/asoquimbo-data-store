# == Schema Information
#
# Table name: custom_select_lists
#
#  id                     :bigint           not null, primary key
#  model_name_association :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class CustomSelectList < ApplicationRecord
  has_many :custom_option_lists, dependent: :destroy

  validates :model_name_association, presence: true, uniqueness: true

  scope :ordered, -> { order(id: :desc) }
end
