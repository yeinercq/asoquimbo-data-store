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
  has_many :custom_options, dependent: :destroy
  accepts_nested_attributes_for :custom_options, reject_if: :all_blank, allow_destroy: true

  validates :model_field, presence: true
  validate :ensure_at_least_one_custom_option, on: [ :create, :update ]
  validate :exists_one_model_associated, on: :is_destroyed
  validate :custom_options_not_in_use, on: :update

  scope :ordered, -> { order(id: :desc) }

  private

  def ensure_at_least_one_custom_option
    if custom_options.empty? || custom_options.all? { |option| option.marked_for_destruction? }
      errors.add(:base, "debe haber al menos una opción para la lista configurable.")
    end
  end

  def exists_one_model_associated
    model = custom_select_list.model_name_association.camelize.constantize rescue nil
    if model.exists?
      errors.add(:base, "No se puede eliminar esta lista porque hay una #{I18n.t("activerecord.models.#{custom_select_list.model_name_association}.one")} asociada a ella.")
    end
  end

  def custom_options_not_in_use
    model_class = custom_select_list.model_name_association.camelize.constantize rescue nil
    return unless model_class

    custom_options.each do |option|
      next unless option.marked_for_destruction?

      if model_class.exists?(model_field => option.id)
        errors.add(:base, "No es posible eliminar las opciones porque están siendo utilizadas en una #{I18n.t("activerecord.models.#{custom_select_list.model_name_association}.one")}")
        break
      end
    end
  end
end
