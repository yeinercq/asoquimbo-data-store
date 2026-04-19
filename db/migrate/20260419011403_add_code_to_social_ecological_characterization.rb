class AddCodeToSocialEcologicalCharacterization < ActiveRecord::Migration[7.2]
  def change
    add_column :social_ecological_characterizations, :code, :integer, null: false, default: 0
  end
end
