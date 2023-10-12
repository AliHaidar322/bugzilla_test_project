class Bug < ApplicationRecord
  has_one_attached :screenshot
  belongs_to :creator, class_name: 'User', inverse_of: :bugs
  belongs_to :project
  before_create :set_initial_status
  before_create :set_no_description

  enum status: { initiated: 0, started: 1, completed: 2, resolved: 3 }

  # validate :screenshot_content_type
  validates :title, presence: true, length: { minimum: 10 }
  validates :title,
            format: { with: /\A.*[a-zA-Z].*\z/,
                      message: I18n.t('activerecord.errors.models.bug.attributes.title.invalid_format') }

  validates :deadline, presence: true
  validates :bug_type, presence: true
  validates :screenshot, content_type: ["image/gif", "image/jpeg"]

  private

  def set_initial_status
    return if status.present?

    self.status = 'initiated'
  end

  def set_no_description
    return if description.present?

    self.description = 'No Description'
  end
end
