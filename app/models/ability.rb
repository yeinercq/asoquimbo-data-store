# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.admin? || user.derector? || user.coodinator?
      can :manage, MonthlyReport, user: user
      can :read, MonthlyReport do |report|
        report.user != user
      end
      can :read, Activity do |report|
        report.monthly_report.user != user
      end
      if user.admin?
        can :manage, User
      end
    end

    can :manage, MonthlyReport, user: user
    can :manage, Activity, monthly_report: { user: user }
  end
end
