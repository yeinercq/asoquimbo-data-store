# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.admin?
      can :manage, User
      can :read, MonthlyReport
      can :trigger_status, MonthlyReport do |report|
        report.user_id != user.id
      end
    end

    if user.director?
      can :read, MonthlyReport
      can :manage, MonthlyReport, user: user
      can :trigger_status, MonthlyReport do |report|
        report.user.coordinator?
      end
    end

    if user.coordinator?
      can :read, MonthlyReport
      can :manage, MonthlyReport, user: user
      can :trigger_status, MonthlyReport do |report|
        report.user.professional?
      end
    end

    if user.inspector?
      can :read, MonthlyReport
      can :trigger_status, MonthlyReport do |report|
        report.user_id != user.id
      end
    end

    can :manage, MonthlyReport, user: user
    cannot :trigger_status, MonthlyReport, user: user
    can :manage, Activity, monthly_report: { user: user }
  end
end
