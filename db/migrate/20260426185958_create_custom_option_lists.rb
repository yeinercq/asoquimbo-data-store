class CreateCustomOptionLists < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_option_lists do |t|
      t.references :custom_select_list, null: false, foreign_key: true
      t.string :model_field, null: false

      t.timestamps
    end
  end
end
