class CreateMasterTermGroups < ActiveRecord::Migration
  def change
    create_table :master_term_groups do |t|
      t.string :name
      t.string :name_translated
      t.integer :master_style_id
      t.integer :master_federation_id

      t.timestamps
    end
  end
end
