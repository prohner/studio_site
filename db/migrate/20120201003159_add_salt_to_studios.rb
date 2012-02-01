class AddSaltToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :salt, :string
  end
  
  def self.down
    remove_column :studios, :salt
  end
end
