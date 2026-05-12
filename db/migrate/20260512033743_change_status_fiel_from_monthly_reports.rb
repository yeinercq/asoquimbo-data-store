class ChangeStatusFielFromMonthlyReports < ActiveRecord::Migration[7.2]
  def up
    change_column :monthly_reports, :status, :string, default: nil
  end

  def down
    change_column :monthly_reports, :status, :string, default: "reported"
  end
end
