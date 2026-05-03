class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.integer :project
      t.integer :associated_objective
      t.integer :activity_name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.integer :status
      t.references :monthly_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
