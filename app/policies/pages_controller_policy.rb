class PagesControllerPolicy < ApplicationPolicy
  def access?
    %w[админ].include?(user.role)
  end
end
