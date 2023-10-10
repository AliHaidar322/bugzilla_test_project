require 'rails_helper'

RSpec.describe UserProject do
  describe "When User Added to a Project" do
    it { is_expected.to have_attribute(:user_id) }
    it { is_expected.to have_attribute(:project_id) }
  end

  describe "scopes" do
    it "returns user_projects related to a specific project" do
      user1 = create(:user)
      user2 = create(:user)
      project1 = create(:project)
      project2 = create(:project)
      user_project1 = create(:user_project, user: user1, project: project1)
      user_project2 = create(:user_project, user: user2, project: project2)

      expect(described_class.return_related_to_project(project1.id)).to include(user_project1)
      expect(described_class.return_related_to_project(project2.id)).to include(user_project2)
    end
  end
end
