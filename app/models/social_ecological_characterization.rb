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

  scope :ordered, -> { order(id: :desc) }

  mount_uploader :source_file, SourceFileUploader

  enum :resource_type, {
    "artículo": 1,
    "informe": 2,
    "tesis": 3,
    "documento institucional": 4
  }
  enum :access_level, {
    "público": 1,
    "parcial": 2,
    "restringido": 3
  }
  enum :geographic_area, {
    "vereda": 1,
    "municipio": 2,
    "zona": 3,
    "departamento": 4
  }
  enum :spatial_coverage, {
    "local": 1,
    "regional": 2,
    "nacional": 3,
    "cuenca": 4
  }
  enum :analysis_scale, {
    "individual": 1,
    "comunidad": 2,
    "región": 3
  }
  enum :approach, {
    "ecológico": 1,
    "social": 2,
    "socioecológico": 3
  }

  def source_file_size_validation
    if source_file.size > 10.megabytes
      errors.add(:source_file, I18n.t("activerecord.errors.messages.file_size_exceeded"))
    end
  end
end
