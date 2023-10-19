require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  context "Creating a User" do
    describe "validations" do
      it "requires the presence of a name" do
        user = build(:user, name: nil)
        expect(user.valid?).to be(false)
        expect(user.errors[:name]).to include("can't be blank")
      end

      it "allows a user with a name present" do
        user = build(:user, name: "Not Nil Name")
        expect(user.valid?).to be(true)
      end

      it "validates the maximum length of the name" do
        user = build(:user, name: Faker::Lorem.sentence(word_count: 50))
        expect(user.valid?).to be(false)
        expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
      end

      it "allows a user with a maximum of 50 letters in their name" do
        user = build(:user, name: "Ali Haidar")
        expect(user.valid?).to be(true)
      end

      it "validates for the presence of user_type" do
        user = build(:user, user_type: nil)
        expect(user.valid?).to be(false)
        expect(user.errors[:user_type]).to include("can't be blank")
      end

      it "allows a user with user_type present" do
        user = build(:user, user_type: :manager)
        expect(user.valid?).to be(true)
      end
    end

    describe "user_type enum" do
      it "does not allow values other than [:manager, :developer, :qa]" do
        expect { build(:user, user_type: :invalid) }.to raise_error(ArgumentError)
          .with_message(/is not a valid user_type/)
      end

      it "allows values [:manager, :developer, :qa]" do
        user.user_type = :manager
        expect(user).to be_valid
      end
    end
  end

  context "Scopes" do
    describe "non_manager_users_except_project scope" do
      it "returns non-manager users except those associated with a specific project" do
        manager = build(:user, user_type: "manager")
        non_manager = create(:user, user_type: "developer")
        project = build(:project)
        project.users << manager

        expect(non_manager.projects).not_to include(project)

        users = described_class.non_manager_users_except_project(project.id)

        expect(users).to include(non_manager)
        expect(users).not_to include(manager)
      end

      it "excludes manager users assigned to the project" do
        project = build(:project)
        user = build(:user, user_type: "manager")
        create(:user_project, user: user, project: project)

        result = described_class.non_manager_users_except_project(project.id)

        expect(result).not_to include(user)
      end

      it "excludes non-manager users assigned to the project" do
        project = build(:project)
        user = build(:user, user_type: :developer)
        build(:user_project, user: user, project: project)

        result = described_class.non_manager_users_except_project(project.id)

        expect(result).not_to include(user)
      end
    end
  end
end
