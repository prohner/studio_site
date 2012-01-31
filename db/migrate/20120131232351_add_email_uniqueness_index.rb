class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :studios, :email, :unique => true
  end

  def self.down
    remove_index :studios, :email
  end
end
