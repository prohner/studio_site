class CreateMasterTerms < ActiveRecord::Migration
  def change
    create_table :master_terms do |t|
      t.string :term
      t.string :term_translated
      t.text :description
      t.integer :master_term_group_id

      t.timestamps
    end
  end
end
