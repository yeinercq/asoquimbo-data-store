class CreateCustomSelectLists < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_select_lists do |t|
      t.string :model_name_association, null: false
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
