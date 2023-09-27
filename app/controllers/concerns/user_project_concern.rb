# app/controllers/concerns/user_project_related.rb

module UserProjectConcern
  extend ActiveSupport::Concern
  included do
    before_action :find_project, except: [:users, :add_user]
  end

  private

  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Project not found.'
    redirect_to projects_path
  end

end