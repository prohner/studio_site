class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :telephone
      t.string :fax

      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end  
end
