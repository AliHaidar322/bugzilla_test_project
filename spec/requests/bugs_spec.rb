require "rails_helper"
RSpec.describe "Bugs" do
  let(:user) { create(:user, :qa) }
  let(:project) { create(:project) }
  let(:bug) { create(:bug, project: project) }

  before { sign_in user }

  describe "GET /bugs/index" do
    it "checks the project existence" do
      get project_bugs_path(project)
      expect(assigns(:project)).to eq(project)
      expect(response.body).to render_template("bugs/index")
    end

    it "redirects to projects_path and sets a flash alert for project not find" do
      project.id = "noneexistent_id"
      get project_bugs_path(project)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_project_found"))
    end

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
      expect(response.body).to render_template("users/sessions/new")
    end
  end

  describe "GET /bugs/new" do
    it "checks the project existence" do
      get new_project_bug_path(project)
      expect(assigns(:project)).to eq(project)
      expect(response.body).to render_template("bugs/new")
    end

    it "redirects to projects_path and sets a flash alert for project not find" do
      project.id = "noneexistent_id"
      get new_project_bug_path(project)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_project_found"))
    end

    it "renders the new template when user signed in" do
      get new_project_bug_path(project)
      expect(response).to render_template(:new)
    end

    it "does not renders the new template when user signed out" do
      sign_out user
      get new_project_bug_path(project)
      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to render_template("users/sessions/new")
    end

    it "checks authoriztion for new" do
      user = build(:user, :developer)
      sign_in user
      get new_project_bug_path(project)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "POST /bugs" do
    let(:valid_bug_params) { attributes_for(:bug, project_id: project.id) }
    let(:invalid_bug_params) { { title: "", description: "" } }
    let(:user) { create(:user, :qa) }

    it "checks the project existence" do
      post project_bugs_path(project), params: { bug: valid_bug_params }
      expect(assigns(:project)).to eq(project)
      expect(response).to redirect_to(bugs_path(project_id: project.id))
    end

    it "redirects to projects_path and sets a flash alert for project not find" do
      project.id = "noneexistent_id"
      post project_bugs_path(project), params: { bug: valid_bug_params }
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_project_found"))
    end

    it "creates a new bug with valid parameters and missing project_id" do
      expect do
        post project_bugs_path(project), params: { bug: valid_bug_params }
      end.to change(Bug, :count).by(1)

      expect(response).to redirect_to(bugs_path(project_id: project.id))
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq("Bug added successfully.")
    end

    it "does not create a new bug with invalid parameters" do
      expect do
        post project_bugs_path(project), params: { bug: invalid_bug_params }
      end.not_to change(Bug, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq("Bug not added.")
    end

    it "checks authoriztion for Update" do
      user = build(:user, :developer)
      sign_in user
      post project_bugs_path(project), params: { bug: valid_bug_params }
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "PATCH /bugs/:id/assign" do
    let(:user) { create(:user, :developer) }

    it "checks bug existence" do
      patch assign_bug_path(bug)
      expect(assigns(:bug)).to eq(bug)
      expect(response).to redirect_to(projects_path)
    end

    it "redirects to projects_path and sets a flash alert for bug not find" do
      bug.id = "noneexistent_id"
      patch assign_bug_path(bug)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_bug_found"))
    end

    it "assigns the bug to the current user" do
      patch assign_bug_path(bug)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(projects_path)
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq("Bug assigned successfully.")
    end

    it "fails to assign the bug" do
      allow_any_instance_of(Bug).to receive(:update).and_return(false)

      patch assign_bug_path(bug)
      expect(flash[:alert]).to eq("Bug is not assigned.")
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "GET /bugs/:id/edit_status" do
    let(:user) { create(:user, :developer) }

    it "checks bug existence" do
      get edit_status_bug_path(bug)
      expect(response).to have_http_status(:success)
    end

    it "redirects to projects_path and sets a flash alert for bug not find" do
      bug.id = "noneexistent_id"
      get edit_status_bug_path(bug)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_bug_found"))
    end

    it "returns a successful response" do
      get edit_status_bug_path(bug)
      expect(response).to have_http_status(:success)
    end

    it "renders the edit_status template" do
      get edit_status_bug_path(bug)
      expect(response).to render_template(:edit_status)
    end
  end

  describe "PATCH /bugs/:id/update_status" do
    let(:user) { create(:user, :developer) }

    it "checks bug existence" do
      patch update_status_bug_path(bug), params: { bug: { status: :resolved } }
      expect(response).to redirect_to(projects_path)

      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it "redirects to projects_path and sets a flash alert for bug not find" do
      bug.id = "noneexistent_id"
      get edit_status_bug_path(bug), params: { bug: { status: :resolved } }
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq(I18n.t("flash.no_bug_found"))
    end

    it "updates the bug status" do
      patch update_status_bug_path(bug), params: { bug: { status: :resolved } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(projects_path)

      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(flash[:success]).to eq("Bug status updated successfully.")
    end

    it "fails to update bug status" do
      allow_any_instance_of(Bug).to receive(:update).and_return(false)

      patch update_status_bug_path(bug), params: { bug: { status: :resolved } }

      expect(flash[:alert]).to eq("Failed to update bug status.")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit_status)
    end

    it "checks authoriztion for update_status" do
      user = build(:user, :qa)
      sign_in user
      patch update_status_bug_path(bug), params: { bug: { status: :resolved } }
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end
end
