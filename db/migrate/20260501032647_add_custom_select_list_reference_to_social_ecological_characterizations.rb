class AddCustomSelectListReferenceToSocialEcologicalCharacterizations < ActiveRecord::Migration[7.2]
  def change
    add_reference :social_ecological_characterizations, :custom_select_list, null: false, foreign_key: true
  end
end
