module BugConcern
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :find_project, only: [:index, :new, :create]
    before_action :find_bug, only: [:assign, :edit_status, :update_status]
    # rubocop:enable Rails/LexicallyScopedActionFilter
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :screenshot, :project_id)
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('flash.no_project_found')
    redirect_to projects_path
  end

  def find_bug
    @bug = Bug.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('flash.no_bug_found')
    redirect_to projects_path
  end

  def handle_record_not_found
    flash[:alert] = I18n.t('flash.no_bug_found')
    redirect_to projects_path
  end
end
