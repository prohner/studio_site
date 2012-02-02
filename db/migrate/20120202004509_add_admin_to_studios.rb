class AddAdminToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :studios, :admin
  end  
end
