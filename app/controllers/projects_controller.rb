# ProjectController handles the actions related to managing projects in the application.
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.user_type == "qa"
      @projects = Project.all
    else
      @projects = current_user.projects
      if @projects.empty?
        flash.now[:notice] = "You don't have any projects. Click below to create a new project."
        @create_project_button = true
      end
    end
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project
    current_user.projects << @project
    if @project.save
      redirect_to projects_path, notice: 'Project created successfully.'
    else
      render 'new'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.bugs.destroy_all
    if UserProject.where(project_id: params[:id]).destroy_all
      @project.destroy
      redirect_to projects_path, notice: 'Project deleted successfully.'
    else
      redirect_to projects_path, notice: 'Project not Deleted'
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize @project
  end

  def update
    @project = Project.find(params[:id])
    authorize @project
    if @project.update(project_params)
      redirect_to projects_path, notice: "Project updated Sccesfully"
    else
      redirect_to projects_path, notice: "Project not Updated"
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
