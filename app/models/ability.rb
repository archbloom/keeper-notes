# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, note)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :owner
      can :manage, :all
    elsif user.has_role? :collaborator, note
      can :update, note
      can :read, note
    elsif user.has_role? :reader, note
      can :read, note
    end
  end
end
