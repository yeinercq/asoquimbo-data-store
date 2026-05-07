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
#  status                :string
#  transitions           :jsonb
#
class MonthlyReport < ApplicationRecord
  include AASM

  attr_accessor :current_user

  validates :date_period, :component, presence: true

  belongs_to :user
  belongs_to :custom_select_list
  has_many :activities, dependent: :destroy

  scope :ordered, -> { order(id: :desc) }
  scope :filter_by_user_id, ->(user_id) { where(user_id: user_id) }
  scope :filter_by_component, ->(component) { where(component: component) }

  OPTION_LISTABLE_FIELDS = [
    :component
  ].freeze

  ALLOWED_EVENTS_PER_ROLE = {
    "admin" => [ "revise", "unrevise", "approve", "unapprove" ],
    "director" => [ "approve", "unapprove" ],
    "coordinator" => [ "approve", "unapprove" ],
    "inspector" => [ "revise", "unrevise" ]
  }

  def self.allowed_events_per_role
    ALLOWED_EVENTS_PER_ROLE
  end

  def self.option_listable_fields
    OPTION_LISTABLE_FIELDS
  end

  aasm column: :status do
    state :reported, initial: true
    state :revised
    state :approved

    after_all_transitions :log_transition

    event :revise do
      transitions from: :reported, to: :revised
    end

    event :unrevise do
      transitions from: :revised, to: :reported
    end

    event :approve do
      transitions from: :revised, to: :approved
    end

    event :unapprove do
      transitions from: :approved, to: :revised
    end
  end

  private

  def log_transition
    self.transitions ||= []
    self.transitions << {
      from_state: aasm.from_state.to_s,
      to_state: aasm.to_state.to_s,
      current_event: aasm.current_event.to_s,
      timestamp: Time.zone.now,
      user: current_user&.serializable_hash(only: [ :id, :name, :email, :role ])
    }
  end
end
