class AddSourceFileToSocialEcologicalCharacterizations < ActiveRecord::Migration[7.2]
  def change
    add_column :social_ecological_characterizations, :source_file, :string
  end
end
