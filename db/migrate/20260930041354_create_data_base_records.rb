class CreateDataBaseRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :data_base_records do |t|
      t.string :code
      t.integer :ecological_component
      t.string :document_title
      t.string :authors
      t.integer :year, null: false, default: 1900
      t.string :document_type
      t.integer :document_family
      t.string :institutions_entities
      t.text :apa_citation
      t.integer :geographic_area
      t.string :specific_geographic_area
      t.integer :access_level
      t.string :taken_from
      t.text :documental_comment
      t.string :spatial_coverage
      t.string :analysis_scale
      t.integer :territorial_scale
      t.string :study_period
      t.text :study_goal
      t.string :focus_families
      t.string :approach
      t.text :methodology
      t.integer :record_type
      t.references :user, null: false, foreign_key: true
      t.references :custom_select_list, null: false, foreign_key: true
      t.string :source_file

      t.timestamps
    end
  end
end
