require 'rails_helper'
require_relative 'support/database_cleaner'

RSpec.describe Project do
  describe "when creating project" do
    let(:project) { create(:project) }

    it "validate project" do
      expect(project.valid?).to be(true)
    end
  end

  describe "associations" do
    it "has many user_projects" do
      project = create(:project)
      expect(project).to respond_to(:user_projects)
    end

    it "has many users through user_projects" do
      project = create(:project)
      expect(project).to respond_to(:users)
    end

    it "has many bugs" do
      project = create(:project)
      expect(project).to respond_to(:bugs)
    end
  end
end
