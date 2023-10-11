# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User do
  describe 'when creating user' do
    let(:user) { create(:user) }

    it 'validate user' do
      expect(user.valid?).to be(true)
    end

    it 'has many user_projects' do
      expect(user).to respond_to(:user_projects)
    end

    it 'has many projects through user_projects' do
      expect(user).to respond_to(:projects)
    end

    it 'has many bugs as a creator' do
      expect(user).to respond_to(:bugs)
    end
  end

  describe 'scopes' do
    it 'returns non-manager users except those associated with a specific project' do
      manager = create(:user, user_type: 'manager')
      non_manager = create(:user, user_type: 'developer')
      project = create(:project)
      project.users << manager

      expect(non_manager.projects).not_to include(project)

      users = described_class.non_manager_users_except_project(project.id)

      expect(users).to include(non_manager)
      expect(users).not_to include(manager)
    end
  end
end
