class AddUserReferencesToSocialEcologicalCharacterization < ActiveRecord::Migration[7.2]
  def change
    add_reference :social_ecological_characterizations, :user, null: false, foreign_key: true
  end
end
