class BugsController < ApplicationController
  include BugConcern
  def index
    @bugs = @project.bugs
  end

  def new
    @project = Project.find(params[:project_id])
    @bug = Bug.new
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.creator = current_user
    authorize @bug

    if @bug.save
      flash[:success] = 'Bug added successfully.'
      redirect_to bugs_path(project_id: @project.id)
    else
      flash[:alert] = 'Bug not added.'
      render :new, status: :unprocessable_entity
    end
  end

  def assign
    @user = current_user

    if @bug.update(assign_to_id: @user.id)
      flash[:success] = 'Bug assigned successfully.'
    else
      flash[:alert] = 'Bug is not assigned.'
    end

    redirect_to projects_path
  end

  def edit_status; end

  def update_status
    authorize @bug
    if @bug.update(bug_params)
      flash[:success] = 'Bug status updated successfully.'
      redirect_to projects_path
    else
      flash[:alert] = 'Failed to update bug status.'
      render :edit_status, status: :unprocessable_entity
    end
  end
end
