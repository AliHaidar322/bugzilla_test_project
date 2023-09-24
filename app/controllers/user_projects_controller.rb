class UserProjectsController < ApplicationController
  def add_to_project
    @user_project = UserProject.new(project_id: params[:id], user_id: params[:id1])
    authorize @user_project
    if @user_project.save
      flash[:success] = "User added to the project successfully."
      redirect_to root_path
    else
      flash[:error] = "Failed to add user to the project."
      render 'userprojects/user_edit'
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
         redirect_to root_path, notice: "Object deleted Succesfully."
      else
        redirect_to userprojects_users_path, notice: "Object was not deleted."
        end
    else
      redirect_to userprojects_users_path
    end
  end
end
