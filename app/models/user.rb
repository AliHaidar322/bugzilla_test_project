class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,  :trackable

  enum user_type: { manager: 'manager', developer: 'developer', qa: 'qa' }

  validates :name, presence: true
  validates :user_type, presence: true
end
