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
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to projects_path }
      end
    else
      flash[:alert] = 'There was an error creating the project.'
      render turbo_stream: :new, status: :unprocessable_entity, headers: { turbolinks_visit: request.url }
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      flash[:success] = "Project updated successfully."
      redirect_to projects_path
    else
      flash[:alert] = "Project not updated."
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize @project
    @project.bugs.destroy_all
    @user_projects = UserProject.return_related_to_project(@project.id)
    if @user_projects.destroy_all
      @project.destroy
      flash[:success] = 'Project deleted successfully.'
    else
      flash[:alert] = 'Project not deleted!.'
    end
    redirect_to projects_path
  end
end
