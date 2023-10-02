class ProjectPolicy < ApplicationPolicy
  def new?
    user.manager?
  end

  alias create? new?
  alias edit? new?
  alias update? new?
  alias destroy? new?
end
