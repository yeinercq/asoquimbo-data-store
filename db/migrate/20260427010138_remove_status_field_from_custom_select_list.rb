class RemoveStatusFieldFromCustomSelectList < ActiveRecord::Migration[7.2]
  def change
    remove_column :custom_select_lists, :status, :integer
  end
end
