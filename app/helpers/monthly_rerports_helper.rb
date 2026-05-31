module MonthlyRerportsHelper
  def available_events_for(monthly_report)
    monthly_report.aasm.permitted_transitions.map { |r| r[:event] }
  end

  def event_date_format(date)
    if date.nil?
      "-"
    else
      date.to_time.strftime("%d/%m/%Y %H:%M")
    end
  end
end
