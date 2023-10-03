# app/controllers/concerns/project_related.rb

module ProjectConcern
  extend ActiveSupport::Concern

  included do
    # rubocop:disable Rails/LexicallyScopedActionFilter
    before_action :find_project, only: [:destroy, :edit, :update]
    # rubocop:enable Rails/LexicallyScopedActionFilter
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def handle_record_not_found
    flash[:alert] = I18n.t('flash.no_project_found')
    redirect_to projects_path
  end

  def set_flash_if_no_projects
    return unless @projects.empty?

    flash.now[:notice] = I18n.t('flash.you_have_no_project')

    @create_project_button = true
  end
end
