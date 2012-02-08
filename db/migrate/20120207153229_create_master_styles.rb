class CreateMasterStyles < ActiveRecord::Migration
  def change
    create_table :master_styles do |t|
      t.string :name

      t.timestamps
    end
  end
end
