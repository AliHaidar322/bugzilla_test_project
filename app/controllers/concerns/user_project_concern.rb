# app/controllers/concerns/user_project_related.rb

module UserProjectConcern
  extend ActiveSupport::Concern
  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :find_project, only: [:users, :add_user]
    before_action :find_user_and_user_project, only: [:remove_from_project]
    # rubocop:enable Rails/LexicallyScopedActionFilter
  end

  private

  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('flash.no_project_found')
    redirect_to projects_path
  end

  def find_user_and_user_project
    @user = User.find(params[:id1])
    @project = Project.find(params[:id])
    @user_project = UserProject.find_by(project_id: params[:id], user_id: @user.id)
    authorize @user_project
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('flash.no_record_found')
    redirect_to users_user_project_path
  end

  def user_already_added?(user_id, project_id)
    UserProject.check_if_user_added_before?(user_id, project_id)
  end

  def add_user_to_project(user_id, project_id)
    @user_project = UserProject.new(project_id: project_id, user_id: user_id)
    authorize @user_project
    if @user_project.save
      flash[:success] = I18n.t('flash.added_successfully')
    else
      flash[:error] = I18n.t('flash.error_adding_user')
    end
  end
end
