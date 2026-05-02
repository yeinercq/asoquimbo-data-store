class AddCustomSelectListReferencesToMonthlyReports < ActiveRecord::Migration[7.2]
  def change
    add_reference :monthly_reports, :custom_select_list, null: false, foreign_key: true
  end
end
