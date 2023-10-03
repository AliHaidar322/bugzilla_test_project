# UserProjectsController handles the actions related to managing users and Projects in the application.
class UserProjectsController < ApplicationController
  include UserProjectConcern
  def add_to_project
    if user_already_added?(params[:user_id], params[:project_id])
      flash[:error] = "User is Already There."
    else
      add_user_to_project(params[:user_id], params[:project_id])
    end

    redirect_to add_user_user_project_path
  end

  def users
    @users = @project.users
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'No User found'
    redirect_to projects_path
  end

  def add_user
    @users = User.non_manager_users_except_project(@project.id)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'All Users Added in the Project'
    redirect_to projects_path
  end

  def remove_from_project
    if @user_project.destroy
      flash[:success] = "Removed Successfully."
    else
      flash[:error] = "Error while Removing User."
    end
    redirect_to users_user_project_path
  end
end
