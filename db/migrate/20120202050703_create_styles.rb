class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.integer :studio_id

      t.timestamps
    end
    
    add_index :styles, [:studio_id, :created_at]
  end
end
