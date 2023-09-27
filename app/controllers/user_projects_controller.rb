# UserProjectsController handles the actions related to managing users and Projects in the application.
class UserProjectsController < ApplicationController
  def add_to_project
    if UserProject.check_if_user_added_before?(params[:user_id], params[:project_id])
      @user_project = UserProject.new(project_id: params[:project_id], user_id: params[:user_id])
      authorize @user_project
      if @user_project.save
        flash[:success] = "Added  successfully."
      else
        flash[:error] = "Error while Adding User."
      end
    else
      flash[:error] = "User is Already There."
    end
    redirect_to add_user_user_project_path
  end

  def users
    @project = Project.find(params[:id])
    @users = @project.users
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'No User found'
    redirect_to projects_path
  end

  def add_user
    @project = Project.find(params[:id])
    @users = User.non_manager_users_except_project(@project.id)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'All Users Added in the Project'
    redirect_to projects_path
  end

  def remove_from_project
    @user = User.find(params[:id1])
    @project = Project.find(params[:id])
    @user_project = UserProject.find_by(project_id: params[:id], user_id: @user.id)
    authorize @user_project
    if @user_project.destroy
      flash[:success] = "Removed Succesfully."
    else
      flash[:error] = "Error while Removing User."
    end
    redirect_to users_user_project_path
  end
end
