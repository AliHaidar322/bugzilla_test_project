class Bug < ApplicationRecord
  has_one_attached :screenshot
  belongs_to :user
  belongs_to :project

  enum status: { initiated: 0, started: 1, completed: 2, resolved: 3 }

  validate :screenshot_content_type
  validates :title, presence: true
  validates :deadline, presence: true
  validates :bug_type, presence: true
  validates :status, presence: true

  private

  def screenshot_content_type
    return unless screenshot.attached? && !screenshot.content_type.in?(%w[image/png image/gif])

    screenshot.purge
    errors.add(:screenshot, 'must be a PNG or GIF image')
  end
end
