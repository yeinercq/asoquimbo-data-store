# == Schema Information
#
# Table name: activities
#
#  id                    :bigint           not null, primary key
#  project               :integer
#  associated_objective  :integer
#  activity_name         :integer
#  description           :text
#  start_date            :date
#  end_date              :date
#  status                :integer
#  monthly_report_id     :bigint           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  custom_select_list_id :bigint           not null
#  source_files          :json
#
class Activity < ApplicationRecord
  validates :project,
  :associated_objective,
  :activity_name,
  :description,
  :start_date,
  :status,
  presence: true
  validate :source_file_size_validation

  belongs_to :monthly_report
  belongs_to :custom_select_list

  scope :ordered, -> { order(id: :desc) }

  enum :status, {
    "pendiente": 0,
    "en ejecución": 1,
    "cumplida": 2
  }

  mount_uploaders :source_files, SourceFileUploader

  OPTION_LISTABLE_FIELDS = [
    :project, :associated_objective, :activity_name
  ].freeze

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end

  private

  def source_file_size_validation
    source_files.each do |source_file|
      if source_file.size > 5.megabytes
        errors.add(:source_files, I18n.t("activerecord.errors.messages.file_size_exceeded"))
      end
    end
  end
end
