class MonthlyReports::TriggerEventService
  def call(monthly_report, event, current_user)
    monthly_report.current_user = current_user
    allowed_events = MonthlyReport.allowed_events_per_role
    if allowed_events.keys.include?(current_user.role) && allowed_events[current_user.role].include?(event)
      monthly_report.send "#{event}!"
      [ true, "Informe mensual ha sido actualizado correctamente." ]
    else
      [ false, "No tiene permisos para esta acción." ]
    end
  rescue => e
    Rails.logger.error e
    [ false, "No fue posible actulizar el informe mensual: #{e.message}" ]
  end
end
