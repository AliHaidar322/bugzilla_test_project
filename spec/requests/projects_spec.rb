require "rails_helper"

RSpec.describe "Projects" do
  let(:user) { create(:user, :manager) }
  let(:project) { create(:project) }

  before { sign_in user }

  describe "GET /projects" do
    context "when user is a QA" do
      let(:qa_user) { build(:user, :qa) }

      it "returns a successful response" do
        sign_in qa_user
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get projects_path
        expect(response).to render_template(:index)
      end
    end

    context "when user is not a QA" do
      it "returns a successful response" do
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get projects_path
        expect(response).to render_template(:index)
      end

      it "assigns current user\"s projects to @projects" do
        user.projects << project
        get projects_path
        expect(assigns(:projects)).to eq([project])
      end
    end

    context "when user has no project" do
      it "sets a flash message if the user has no projects" do
        user_without_project = create(:user, :manager, projects: [])
        sign_in user_without_project

        get projects_path
        expect(flash[:notice]).to eq(I18n.t("flash.you_have_no_project"))
      end
    end
  end

  describe "GET project/new" do
    it "renders new action" do
      get new_project_path(format: :turbo_stream)
      expect(response).to render_template("projects/new")
    end

    it "checks authoriztion for new" do
      user = build(:user, :developer)
      sign_in user
      get new_project_path(format: :turbo_stream)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "Create Project" do
    it "creates the project with valid parameters" do
      project_params = {
        name: Faker::Lorem.unique.words(number: 1, supplemental: true).join(" "),
        description: Faker::Lorem.sentence(word_count: 15) [0..99]
      }

      post projects_path, params: { project: project_params }

      expect(Project.find_by(name: project_params[:name])).to be_present
    end

    it "raise error for creating project with invalid params" do
      project_params = {
        name: nil,
        description: Faker::Lorem.sentence(word_count: 15) [0..99]
      }

      post projects_path, params: { project: project_params }
      expect(flash[:alert]).to eq("There was an error creating the project.")
    end

    it "checks authorization for create" do
      user = build(:user, :developer)
      sign_in user
      project_params = {
        name: Faker::Lorem.unique.words(number: 1, supplemental: true).join(" "),
        description: Faker::Lorem.sentence(word_count: 15) [0..99]
      }

      post projects_path, params: { project: project_params }
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "GET /projects/:id/edit" do
    it "returns a successful response" do
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end

    it "renders the edit template" do
      get edit_project_path(project)
      expect(response).to render_template(:edit)
    end

    it "checks authorization for edit" do
      user = build(:user, :developer)
      sign_in user
      get edit_project_path(project)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "PATCH /projects/:id" do
    context "with valid parameters" do
      it "updates the project" do
        new_name = project.name
        patch project_path(project), params: { project: { name: new_name } }
        project.reload
        expect(project.name).to eq(new_name)
        expect(response).to redirect_to(projects_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the project" do
        invalid_name = ""
        patch project_path(project), params: { project: { name: invalid_name } }
        project.reload
        expect(project.name).not_to eq(invalid_name)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end

    it "checks authoriztion for update" do
      user = build(:user, :developer)
      sign_in user
      patch project_path(project)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "DELETE /projects/:id" do
    it "deletes the project" do
      delete project_path(project)
      expect(Project).not_to exist(project.id)
      expect(response).to redirect_to(projects_path)
    end

    it "fails to delete the project and sets a flash message" do
      user_projects = project.user_projects
      allow(UserProject).to receive(:return_related_to_project).and_return(project.user_projects)
      allow(user_projects).to receive(:destroy_all).and_return(false)
      delete project_path(project)
      expect(flash[:alert]).to eq("Project not deleted!.")
    end

    it "checks authoriztion for destroy" do
      user = build(:user, :developer)
      sign_in user
      delete project_path(project)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end
end
