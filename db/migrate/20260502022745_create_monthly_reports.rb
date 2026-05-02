class CreateMonthlyReports < ActiveRecord::Migration[7.2]
  def change
    create_table :monthly_reports do |t|
      t.string :date_period
      t.references :user, null: false, foreign_key: true
      t.integer :component

      t.timestamps
    end
  end
end
