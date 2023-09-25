class ProjectPolicy < ApplicationPolicy
  def new?
    user.manager?
  end

  def create?
    user.manager?
  end

  def edit?
    update?
  end

  def update?
    user.manager?
  end

  def destroy?
    user.manager?
  end
end
