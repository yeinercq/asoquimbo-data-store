class AddGoalToMonthlyReport < ActiveRecord::Migration[7.2]
  def change
    add_column :monthly_reports, :goal, :text
  end
end
