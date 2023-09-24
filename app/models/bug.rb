class Bug < ApplicationRecord
  belongs_to :user
  belongs_to :project

  enum status: { initiated: 0, started: 1, completed: 2, resolved: 3 }

  validates :title, presence: true
  validates :deadline, presence: true
  validates :bug_type, presence: true
  validates :status, presence: true
end
