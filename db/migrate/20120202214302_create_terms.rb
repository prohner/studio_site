class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :term
      t.string :term_translated
      t.text :description
      t.string :phonetic_spelling
      t.integer :term_group_id

      t.timestamps
    end
  end
end
