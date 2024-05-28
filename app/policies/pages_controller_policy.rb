class PagesControllerPolicy < ApplicationPolicy
  def access?
    %w[вдмин].include?(user.role)
  end
end
