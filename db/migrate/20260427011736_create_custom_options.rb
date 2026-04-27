class CreateCustomOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_options do |t|
      t.references :custom_option_list, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
