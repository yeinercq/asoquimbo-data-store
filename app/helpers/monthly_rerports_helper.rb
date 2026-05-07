module MonthlyRerportsHelper
  def available_events_for(monthly_report)
    monthly_report.aasm.permitted_transitions.map { |r| r[:event] }
  end
end
