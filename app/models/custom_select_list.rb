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
  has_many :custom_options, through: :custom_option_lists

  validates :model_name_association, presence: true, uniqueness: true

  scope :ordered, -> { order(id: :desc) }
  # scope :find_custom_option_name, ->(custom_option_id) { custom_option_lists.custom_options.find_by(id: custom_option_id)&.name }

  def custom_option_name(custom_option_id)
    custom_options.find_by(id: custom_option_id)&.name
  end
end
