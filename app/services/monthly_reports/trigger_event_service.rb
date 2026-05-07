class MonthlyReports::TriggerEventService
  def call(monthly_report, event, current_user)
    monthly_report.current_user = current_user
    monthly_report.send "#{event}!"
    [ true, "Informe mensual ha sido actualizado correctamente." ]
  rescue => e
    Rails.logger.error e
    [ false, "No fue posible actulizar el informe mensual: #{e.message}" ]
  end
end
