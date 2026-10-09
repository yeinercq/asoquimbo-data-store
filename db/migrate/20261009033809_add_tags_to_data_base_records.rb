class AddTagsToDataBaseRecords < ActiveRecord::Migration[7.2]
  def up
    add_column :data_base_records, :tags, :jsonb
  end

  def down
    remove_column :data_base_records, :tags
  end
end
