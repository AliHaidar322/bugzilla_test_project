class BugPolicy < ApplicationPolicy
  def create?
    user.qa?
  end

  def update_status?
    user.developer?
  end
  alias assign? update_status?
end
