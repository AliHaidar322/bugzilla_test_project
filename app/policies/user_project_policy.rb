class UserProjectPolicy < ApplicationPolicy
  def add_user?
    user.manager?
  end

  alias add_to_project? add_user?
  alias remove_from_project? add_user?
end
