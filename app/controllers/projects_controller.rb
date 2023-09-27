class ProjectsController < ApplicationController
  include ProjectConcern

  def index
    if current_user.qa?
      @projects = Project.all
    else
      @projects = current_user.projects
      set_flash_if_no_projects
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
      flash[:success] = 'Project created successfully.'
      redirect_to projects_path
    else
      flash[:alert] = 'There was an error creating the project.'
      redirect_to projects_path
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      flas[:success] = "Project updated successfully."
    else
      flas[:alert] = "Project not updated."
    end
    redirect_to projects_path
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.bugs.destroy_all
    if UserProject.destroy_related_to_project(@project.id)
      @project.destroy
      flas[:success] = 'Project deleted successfully.'
    else
      flas[:alert] = 'Project deleted successfully.'
    end
    redirect_to projects_path
  end
end
