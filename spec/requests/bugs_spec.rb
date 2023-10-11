require 'rails_helper'
RSpec.describe "Bugs" do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:bug) { create(:bug, project: project) }

  before { sign_in user }

  describe "GET /bugs/index" do
    it "shows bugs related to the project when the user is signed in" do
      get project_bugs_path(project.id)
      expect(response).to have_http_status(:success)
      expect(project.bugs).to include(bug)
    end

    it "redirects to sign-in when the user is not signed in" do
      sign_out user
      get project_bugs_path(project.id)
      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to render_template("devise/sessions/new")
    end
  end

  describe 'GET /bugs/new' do
    it 'renders the new template when user signed in' do
      get new_project_bug_path(project)
      expect(response).to render_template(:new)
    end

    it 'does not renders the new template when user signed out' do
      sign_out user
      get new_project_bug_path(project)
      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to render_template("devise/sessions/new")
    end
  end

  describe 'POST /bugs' do
    let(:valid_bug_params) { attributes_for(:bug, project_id: project.id) }
    let(:invalid_bug_params) { { title: '', description: '' } }
    let(:user) { create(:user, :qa) }

    it 'creates a new bug with valid parameters and missing project_id' do
      expect do
        post project_bugs_path(project), params: { bug: valid_bug_params }
      end.to change(Bug, :count).by(1)

      expect(response).to redirect_to(bugs_path(project_id: project.id))
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq('Bug added successfully.')
    end

    it 'does not create a new bug with invalid parameters' do
      expect do
        post project_bugs_path(project), params: { bug: invalid_bug_params }
      end.not_to change(Bug, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq('Bug not added.')
    end
  end

  describe 'PATCH /bugs/:id/assign' do
    let(:user) { create(:user, :developer) }

    it 'assigns the bug to the current user' do
      patch assign_bug_path(bug)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(projects_path)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq('Bug assigned successfully.')
    end
  end

  describe 'GET /bugs/:id/edit_status' do
    let(:user) { create(:user, :developer) }

    it 'returns a successful response' do
      get edit_status_bug_path(bug)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit_status template' do
      get edit_status_bug_path(bug)
      expect(response).to render_template(:edit_status)
    end
  end

  describe 'PATCH /bugs/:id/update_status' do
    let(:user) { create(:user, :developer) }
    let(:new_status) { :resolved }
    let(:valid_status_params) { { status: new_status } }

    it 'updates the bug status' do
      patch update_status_bug_path(bug), params: { bug: valid_status_params }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(projects_path)

      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq('Bug status updated successfully.')
    end
  end
end
