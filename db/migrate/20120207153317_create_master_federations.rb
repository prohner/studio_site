class CreateMasterFederations < ActiveRecord::Migration
  def change
    create_table :master_federations do |t|
      t.string :name
      t.integer :master_style_id

      t.timestamps
    end
  end
end
