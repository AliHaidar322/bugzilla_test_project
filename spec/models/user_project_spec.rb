require 'rails_helper'

RSpec.describe UserProject do
  context "Associations" do
    describe "project association" do
      it "belongs to a project" do
        project = build(:project)
        user = build(:user)
        user_project = build(:user_project, project: project, user: user)

        expect(user_project.project).to eq(project)
      end
    end

    describe "user association" do
      it "belongs to a user" do
        project = build(:project)
        user = build(:user)
        user_project = build(:user_project, user: user, project: project)
        expect(user_project.user).to eq(user)
      end
    end
  end

  context "Scopes" do
    describe "return_related_to_project scope" do
      it "returns user projects related to a project" do
        project = build(:project)
        user = build(:user)
        user_project = create(:user_project, user: user, project: project)

        result = described_class.return_related_to_project(project.id)

        expect(result).to include(user_project)
      end

      it "returns an empty result when there are no user projects related to a project" do
        project = build(:project)

        result = described_class.return_related_to_project(project.id)

        expect(result).to be_empty
      end
    end
  end

  context "Callbacks" do
    describe "check_if_user_added_before? callback" do
      it "checks if a user was added before to a project" do
        project = build(:project)
        user = build(:user)
        user_project = create(:user_project, user: user, project: project)

        result = described_class.check_if_user_added_before?(user.id, project.id)

        expect(result).to eq(user_project)
      end

      it "returns nil when a user was not added before to a project" do
        project = build(:project)
        user = build(:user)

        result = described_class.check_if_user_added_before?(user.id, project.id)

        expect(result).to be_nil
      end
    end
  end
end
