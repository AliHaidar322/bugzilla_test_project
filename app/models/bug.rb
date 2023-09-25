class Bug < ApplicationRecord
  has_one_attached :screenshot
  belongs_to :user
  belongs_to :project

  enum status: { initiated: 0, started: 1, completed: 2, resolved: 3 }

  enum

  validates :title, presence: true
  validates :deadline, presence: true
  validates :bug_type, presence: true
  validates :status, presence: true
  validates :screenshot, content_type: ['image/png', 'image/gif'],
  size: { less_than: 5.megabytes }
end
