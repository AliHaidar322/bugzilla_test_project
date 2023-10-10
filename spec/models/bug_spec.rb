require 'rails_helper'
require_relative 'support/database_cleaner'

RSpec.describe Bug do
  describe "when creating bug" do
    let(:bug) { create(:bug) }

    it "validates bug" do
      expect(bug.valid?).to be(true)
    end
  end

  describe "associations" do
    it "associates a user (creator) and a project" do
      bug = create(:bug)
      expect(bug.creator).to be_a(User)
      expect(bug.project).to be_a(Project)
    end
  end

  describe "before_create callbacks" do
    it "sets initial status to 'initiated' if not present" do
      bug = create(:bug, status: nil)
      expect(bug.status).to eq("initiated")
    end

    it "sets description to 'No Description' if not present" do
      bug = create(:bug, description: nil)
      expect(bug.description).to eq('No Description')
    end
  end
end
