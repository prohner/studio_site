class CreateTermGroups < ActiveRecord::Migration
  def change
    create_table :term_groups do |t|
      t.string :name
      t.integer :style_id

      t.timestamps
    end
  end
end
