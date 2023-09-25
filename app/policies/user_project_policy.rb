class UserProjectPolicy < ApplicationPolicy
  def add_user?
    add_to_project?
  end

  def add_to_project?
    user.manager?
  end

  def remove_from_project?
    user.manager?
  end
end
