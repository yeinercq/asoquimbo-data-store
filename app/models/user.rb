# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  role                   :integer
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, :name, :role, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  has_many :social_ecological_characterizations, dependent: :nullify
  has_many :monthly_reports, dependent: :nullify

  scope :ordered_by_name, -> { order(:name) }

  enum :role, {
    derector: 1,
    coodinator: 2,
    professional: 3
  }
end
