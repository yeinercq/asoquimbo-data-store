# == Schema Information
#
# Table name: data_base_records
#
#  id                       :bigint           not null, primary key
#  code                     :string
#  ecological_component     :integer
#  document_title           :string
#  authors                  :string
#  year                     :integer          default(1900), not null
#  document_type            :string
#  document_family          :integer
#  institutions_entities    :string
#  apa_citation             :text
#  geographic_area          :integer
#  specific_geographic_area :string
#  access_level             :integer
#  taken_from               :string
#  documental_comment       :text
#  spatial_coverage         :string
#  analysis_scale           :string
#  territorial_scale        :integer
#  study_period             :string
#  study_goal               :text
#  focus_families           :string
#  approach                 :string
#  methodology              :text
#  record_type              :integer
#  user_id                  :bigint           not null
#  custom_select_list_id    :bigint           not null
#  source_file              :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class DataBaseRecord < ApplicationRecord
  belongs_to :user
  belongs_to :custom_select_list

  # Validations
  validates :document_title,
          :authors,
          :year,
          :document_type,
          :document_family,
          :institutions_entities,
          :apa_citation,
          :geographic_area,
          :specific_geographic_area,
          :access_level,
          :taken_from,
          :documental_comment,
          :spatial_coverage,
          :analysis_scale,
          :territorial_scale,
          :study_period,
          :study_goal,
          :focus_families,
          :approach,
          :methodology,
          :record_type,
          presence: true
  validates :ecological_component, presence: true, if: -> { record_type == "ecologica" }
  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900 }
  validate :source_file_size_validation

  before_create :set_code

  # Scopes to filter and order records
  scope :ordered, -> { order(id: :desc) }
  scope :filter_by_document_family, ->(document_family) { where(document_family: document_family) }
  scope :filter_by_geographic_area, ->(area) { where(geographic_area: area) }
  scope :filter_by_access_level, ->(level) { where(access_level: level) }
  scope :filter_by_territorial_scale, ->(scale) { where(territorial_scale: scale) }
  scope :filter_by_record_type, ->(type) { where(record_type: type) }
  scope :filter_by_year, ->(year) { where(year: year) }

  mount_uploader :source_file, SourceFileUploader

  enum :record_type, metodologia: 1, social: 2, ecologica: 3

  OPTION_LISTABLE_FIELDS = [
    :document_family, :geographic_area, :access_level, :territorial_scale
  ].freeze

  def source_file_size_validation
    if source_file.size > 3.megabytes
      errors.add(:source_file, I18n.t("activerecord.errors.messages.file_size_exceeded"))
    end
  end

  def set_code
    self.code = last_code + 1 if code == 0
  end

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end
end
