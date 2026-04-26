# == Schema Information
#
# Table name: custom_option_lists
#
#  id                    :bigint           not null, primary key
#  custom_select_list_id :bigint           not null
#  model_field           :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class CustomOptionList < ApplicationRecord
  belongs_to :custom_select_list

  validates :model_field, presence: true
end
