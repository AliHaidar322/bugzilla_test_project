class Bug < ApplicationRecord
  has_one_attached :screenshot
  belongs_to :user
  belongs_to :project

  enum status: { initiated: 0, started: 1, completed: 2, resolved: 3 }

  enum
  validate :screenshot_content_type
  validates :title, presence: true
  validates :deadline, presence: true
  validates :bug_type, presence: true
  validates :status, presence: true
  # validates :screenshot, content_type: ['image/png', 'image/gif'],
  # size: { less_than: 5.megabytes }
  private

  def screenshot_content_type
    if screenshot.attached? && !screenshot.content_type.in?(%w(image/jpeg image/png))
      errors.add(:screenshot, 'must be a JPEG or PNG image')
    end
  end
end
