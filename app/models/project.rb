class Project < ApplicationRecord
  has_many :user_projects
  has_many :users, through: :user_projects
  has_many :bugs

  validates :name, presence: true, uniqueness: true
  validates :name,
            format: { with: /\A(?=.*[a-zA-Z])[a-zA-Z0-9]+\z/,
                      message: I18n.t('activerecord.errors.models.project.attributes.name.invalid_format') }
  validates :description, length: { minimum: 10, maximum: 100 }
end
