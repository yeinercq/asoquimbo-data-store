class AddCustonSelectListReferencesToActivities < ActiveRecord::Migration[7.2]
  def change
    add_reference :activities, :custom_select_list, null: false, foreign_key: true
  end
end
