module BugConcern
  extend ActiveSupport::Concern

  included do
    before_action :find_project, only: [:index, :new, :create]
    before_action :find_bug, only: [:assign, :edit_status, :update_status]
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  private
  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :screenshot, :project_id)
  end
  
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'No Project Found'
    redirect_to projects_path
  end

  def find_bug
    @bug = Bug.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'No Bug Found'
    redirect_to projects_path
  end

  def handle_record_not_found
    flash[:alert] = 'Record not found'
    redirect_to projects_path
  end
end
