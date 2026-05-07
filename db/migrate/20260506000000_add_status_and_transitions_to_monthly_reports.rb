class AddStatusAndTransitionsToMonthlyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :monthly_reports, :status, :string, default: "reported"
    add_column :monthly_reports, :transitions, :jsonb, default: []
  end
end
