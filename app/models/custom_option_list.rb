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

  scope :ordered, -> { order(id: :desc) }

  private

  def ensure_at_least_one_custom_option
    if custom_options.empty? || custom_options.all? { |option| option.marked_for_destruction? }
      errors.add(:base, "debe haber al menos una opción para la lista configurable.")
    end
  end
end
