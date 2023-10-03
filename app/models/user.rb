class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs, class_name: 'Bug', foreign_key: 'creator_id', inverse_of: :creator

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  enum user_type: { manager: 0, developer: 1, qa: 2 }

  validates :name, presence: true
  validates :user_type, presence: true

  scope :non_manager_users_except_project, lambda { |project_id|
    where.not(user_type: 'manager')
         .where.not(id: UserProject.where(project_id: project_id).pluck(:user_id))
  }
end
