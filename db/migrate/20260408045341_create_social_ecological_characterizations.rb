class CreateSocialEcologicalCharacterizations < ActiveRecord::Migration[7.2]
  def change
    create_table :social_ecological_characterizations do |t|
      t.string :authors, null: false
      t.integer :year, null: false, default: 1900
      t.string :title, null: false
      t.integer :resource_type, null: false
      t.string :intitution, null: false
      t.string :url, null: false
      t.integer :access_level, null: false
      t.integer :geographic_area, null: false
      t.integer :spatial_coverage, null: false
      t.integer :analysis_scale, null: false
      t.string :study_period, null: false
      t.string :study_objective, null: false
      t.integer :approach, null: false
      t.string :general_methodology_used, null: false

      t.timestamps
    end
  end
end
