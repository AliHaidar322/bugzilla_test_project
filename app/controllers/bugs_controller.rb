class BugsController < ApplicationController
  before_action :authenticate_user!

  def index
    @project = Project.find(params[:id])
    @bugs = @project.bugs
  end

  def new
    @project = Project.find(params[:project_id])
    @bug = Bug.new(status: 'initiated')
  end

  def create
    @project = Project.find(params[:project_id])
    @bug = Bug.new(bug_params)
    authorize @bug
    @bug.user = current_user

    if @bug.save
      flash[:notice] = 'Bug added successfully.'
      redirect_to bugs_path(id: @project.id)
    else
      flash[:alert] = 'Bug not added.'
      render :new
    end
  end

  def assign
    @user = current_user
    @bug = Bug.find(params[:id])
    authorize @bug
    puts @bug
    if @bug.update(assign_to: @user.id)
      flash[:notice] = 'Bug assigned successfully.'
    else
      flash[:alert] = 'Bug is not assigned.'
    end
    redirect_to projects_path
  end

  def edit_status
    @bug = Bug.find(params[:id])
  end

  def update_status
    @bug = Bug.find(params[:id])
    authorize @bug

    if @bug.update(bug_params)
      flash[:notice] = 'Bug status updated successfully.'
      redirect_to root_path
    else
      flash[:alert] = 'Failed to update bug status.'
      render root_path
    end
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :description, :deadline, :bug_type, :status, :id, :screenshot, :project_id)
  end
end
