class UserProject < ApplicationRecord
  belongs_to :project
  belongs_to :user

  scope :destroy_related_to_project, lambda { |project_id|
    where(project_id: project_id).destroy_all
  }

  def self.check_if_user_added_before?(user_id, project_id)
    where(user_id: user_id, project_id: project_id)
  end
end
