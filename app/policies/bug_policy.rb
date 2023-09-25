class BugPolicy < ApplicationPolicy
  def create?
    user.qa?
  end

  def update_status?
    user.developer?
  end

  def assign?
    user.developer?
  end
end
