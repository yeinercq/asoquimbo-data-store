class AddSourceFilesToActivities < ActiveRecord::Migration[7.2]
  def change
    add_column :activities, :source_files, :json
  end
end
