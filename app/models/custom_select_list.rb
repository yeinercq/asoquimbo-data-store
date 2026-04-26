# == Schema Information
#
# Table name: custom_select_lists
#
#  id                     :bigint           not null, primary key
#  model_name_association :string
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class CustomSelectList < ApplicationRecord
  validates :model_name_association, presence: true

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= 1
  end
end
