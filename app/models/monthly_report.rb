# == Schema Information
#
# Table name: monthly_reports
#
#  id                    :bigint           not null, primary key
#  date_period           :date
#  user_id               :bigint           not null
#  component             :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  custom_select_list_id :bigint           not null
#
class MonthlyReport < ApplicationRecord
  validates :date_period, :component, presence: true

  belongs_to :user
  belongs_to :custom_select_list
  has_many :activities, dependent: :destroy

  scope :ordered, -> { order(id: :desc) }

  OPTION_LISTABLE_FIELDS = [
    :component
  ].freeze

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end
end
