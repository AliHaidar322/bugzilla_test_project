class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
