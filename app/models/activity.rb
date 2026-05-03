# == Schema Information
#
# Table name: activities
#
#  id                   :bigint           not null, primary key
#  project              :integer
#  associated_objective :integer
#  activity_name        :integer
#  description          :text
#  start_date           :date
#  end_date             :date
#  status               :integer
#  monthly_report_id    :bigint           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Activity < ApplicationRecord
  validates :project,
  :associated_objective,
  :activity_name,
  :description,
  :start_date,
  :status,
  presence: true

  belongs_to :monthly_report
  belongs_to :custom_select_list

  OPTION_LISTABLE_FIELDS = [
    :project, :associated_objective, :activity_name, :status
  ].freeze

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end
end
