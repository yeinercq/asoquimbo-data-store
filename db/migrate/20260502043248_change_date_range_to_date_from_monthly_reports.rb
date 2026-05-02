class ChangeDateRangeToDateFromMonthlyReports < ActiveRecord::Migration[7.2]
  def up
    change_column :monthly_reports, :date_period, :date, using: "date_period::date"
  end

  def down
    change_column :monthly_reports, :date_period, :string
  end
end
