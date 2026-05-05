# == Schema Information
#
# Table name: social_ecological_characterizations
#
#  id                       :bigint           not null, primary key
#  authors                  :string           not null
#  year                     :integer          default(1900), not null
#  title                    :string           not null
#  resource_type            :integer          not null
#  institution              :string           not null
#  url                      :string           not null
#  access_level             :integer          not null
#  geographic_area          :integer          not null
#  spatial_coverage         :integer          not null
#  analysis_scale           :integer          not null
#  study_period             :string           not null
#  study_objective          :string           not null
#  approach                 :integer          not null
#  general_methodology_used :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  source_file              :string
#  user_id                  :bigint           not null
#  code                     :integer          default(0), not null
#  custom_select_list_id    :bigint           not null
#
class SocialEcologicalCharacterization < ApplicationRecord
  validates :authors,
            :title,
            :resource_type,
            :institution,
            :url,
            :access_level,
            :geographic_area,
            :spatial_coverage,
            :analysis_scale,
            :study_period,
            :study_objective,
            :approach,
            :general_methodology_used,
            presence: true
  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1900 }
  validate :source_file_size_validation

  belongs_to :user
  belongs_to :custom_select_list

  before_create :set_code

  # Scopes to filter and order records
  scope :ordered, -> { order(id: :desc) }
  scope :filter_by_resource_type, ->(type) { where(resource_type: type) }
  scope :filter_by_access_level, ->(level) { where(access_level: level) }
  scope :filter_by_geographic_area, ->(area) { where(geographic_area: area) }
  scope :filter_by_spatial_coverage, ->(coverage) { where(spatial_coverage: coverage) }
  scope :filter_by_analysis_scale, ->(scale) { where(analysis_scale: scale) }
  scope :filter_by_approach, ->(approach) { where(approach: approach) }

  mount_uploader :source_file, SourceFileUploader

  OPTION_LISTABLE_FIELDS = [
    :resource_type, :access_level, :geographic_area, :spatial_coverage, :analysis_scale, :approach
  ].freeze

  def source_file_size_validation
    if source_file.size > 5.megabytes
      errors.add(:source_file, I18n.t("activerecord.errors.messages.file_size_exceeded"))
    end
  end

  def last_code
    SocialEcologicalCharacterization.maximum(:code) || 0
  end

  def set_code
    self.code = last_code + 1 if code == 0
  end

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end
end
