class UserProjectsController < ApplicationController
  before_action :authenticate_user!
  def add_to_project
    @user_project = UserProject.new(project_id: params[:id], user_id: params[:id1])
    authorize @user_project
    if @user_project.save
      flash[:success] = "User added to the project successfully."
      redirect_to user_projects_add_user_path
    else
      flash[:error] = "Failed to add user to the project."
      redirect_to user_projects_add_user_path
    end
  end

  def users
    @project = Project.find(params[:id])
    @users = @project.users
  end

  def add_user
    @project = Project.find(params[:id])
    @users = User.where.not(user_type: "manager").where.not(id: @project.users.pluck(:id))
  end

  def remove_from_project
    @user = User.find(params[:id1])
    @project = Project.find(params[:id])
    if @user.user_type != "manager"
      @user_project = UserProject.find_by(project_id: params[:id], user_id: params[:id1])
      authorize @user_project
      if @user_project.destroy
        flash[:success] = "Object deleted Succesfully."
        redirect_to user_projects_users_path
      else
        flash[:error] = "Object was not deleted."
        redirect_to user_projects_users_path
      end
    else
      redirect_to user_projects_users_path
    end
  end
end
