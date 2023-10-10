require 'rails_helper'

RSpec.describe "Projects" do
  let(:user) { create(:user, :manager)}
  let(:project) { create(:project) }

  before { sign_in user }

  describe 'GET /projects' do
    context 'when user is a QA' do
      it 'returns a successful response' do
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        get projects_path
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not a QA' do
      let(:user) { create(:user, :manager) }

      it 'returns a successful response' do
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        get projects_path
        expect(response).to render_template(:index)
      end

      it 'assigns current user\'s projects to @projects' do
        user.projects << project
        get projects_path
        expect(assigns(:projects)).to eq([project])
      end
    end

    context 'when user has no project' do
      it 'sets a flash message if the user has no projects' do
        user_without_project = create(:user, :manager, projects: [])
        sign_in user_without_project

        get projects_path
        expect(flash[:notice]).to eq(I18n.t('flash.you_have_no_project'))
      end
    end
  end

  describe 'Create Project' do
    it 'renders the new project form and then saves the project' do
      get new_project_path(format: :turbo_stream)
      expect(response).to render_template('projects/new')
      project_params = {
        name: Faker::Lorem.unique.words(number: 1, supplemental: true).join(' '),
        description: Faker::Lorem.sentence(word_count: 15) [0..99]
      }

      post projects_path, params: { project: project_params}

      expect(Project.find_by(name: project_params[:name])).to be_present
    end
  end

  describe 'GET /projects/:id/edit' do
    it 'returns a successful response' do
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      get edit_project_path(project)
      expect(response).to render_template(:edit)
    end
  end
  describe 'PATCH /projects/:id' do
    context 'with valid parameters' do
      it 'updates the project' do
        new_name = project.name
        patch project_path(project), params: { project: { name: new_name } }
        project.reload
        expect(project.name).to eq(new_name)
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the project' do
        invalid_name = ''
        patch project_path(project), params: { project: { name: invalid_name } }
        project.reload
        expect(project.name).not_to eq(invalid_name)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE /projects/:id' do
    it 'deletes the project' do
      delete project_path(project)
      expect(Project.exists?(project.id)).to be_falsey
      expect(response).to redirect_to(projects_path)
    end
  end
end
