# == Schema Information
#
# Table name: monthly_rerports
#
#  id          :bigint           not null, primary key
#  date_period :string
#  user_id     :bigint           not null
#  component   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class MonthlyReport < ApplicationRecord
  validates :date_period, :component, presence: true

  belongs_to :user
  belongs_to :custom_select_list

  scope :ordered, -> { order(id: :desc) }

  OPTION_LISTABLE_FIELDS = [
    :component
  ].freeze

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end
end
