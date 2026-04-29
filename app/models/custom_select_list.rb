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
  validate :exists_one_model_associated, on: :is_destroyed

  scope :ordered, -> { order(id: :desc) }
  # scope :find_custom_option_name, ->(custom_option_id) { custom_option_lists.custom_options.find_by(id: custom_option_id)&.name }

  def custom_option_name(custom_option_id)
    custom_options.find_by(id: custom_option_id)&.name
  end

  private

  def exists_one_model_associated
    model = model_name_association.camelize.constantize rescue nil
    if model.exists?
      errors.add(:base, "No se puede eliminar esta lista porque hay una #{I18n.t("activerecord.models.#{model_name_association}.one")} asociada a ella.")
    end
  end
end
