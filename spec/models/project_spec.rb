require 'rails_helper'

RSpec.describe Project do
  context "Creating a Project" do
    describe "validations" do
      it "requires the presence of a name" do
        project = build(:project, name: nil)
        expect(project.valid?).to be(false)
        expect(project.errors[:name]).to include("can't be blank")
      end

      it "allows a project with a name present" do
        project = build(:project, name: "Facebook")
        expect(project.valid?).to be(true)
      end

      it "validates the format of the name" do
        project = build(:project, name: "124")
        expect(project.valid?).to be(false)
        expect(project.errors[:name]).to include("should contain at least one letter")
      end

      it "allows a project with a name having the right format" do
        project = build(:project, name: "Facebook123")
        expect(project.valid?).to be(true)
      end

      it "validates the uniqueness of the name" do
        project1 = create(:project, name: "Facebook")
        project2 = build(:project, name: "Facebook")
        expect(project1.valid?).to be(true)
        expect(project2.valid?).to be(false)
        expect(project2.errors[:name]).to include("should be unique")
      end

      it "allows a project with a unique name" do
        project1 = create(:project, name: "Facebook")
        project2 = build(:project, name: "Facebook123")
        expect(project1.valid?).to be(true)
        expect(project2.valid?).to be(true)
      end

      it "validates the minimum length of the project description" do
        project = build(:project, description: "short")
        expect(project.valid?).to be(false)
        expect(project.errors[:description]).to include("is too short (minimum is 10 characters)")
      end

      it "validates the maximum length of the project description" do
        project = build(:project, description: Faker::Lorem.sentence(word_count: 500))
        expect(project.valid?).to be(false)
        expect(project.errors[:description]).to include("is too long (maximum is 100 characters)")
      end

      it "allows a project with a valid length of description" do
        project = build(:project, description: "This is a project description.")
        expect(project.valid?).to be(true)
      end
    end

    describe "associations" do
      it "has many user_projects" do
        expect(described_class.reflect_on_association(:user_projects).macro).to eq(:has_many)
      end

      it "has many users through user_projects" do
        expect(described_class.reflect_on_association(:users).macro).to eq(:has_many)
        expect(described_class.reflect_on_association(:users).options[:through]).to eq(:user_projects)
      end

      it "has many bugs" do
        expect(described_class.reflect_on_association(:bugs).macro).to eq(:has_many)
      end
    end
  end
end
