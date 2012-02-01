class AddPasswordToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :encrypted_password, :string
  end

  def self.down
    remove_column :studios, :encrypted_password
  end
end
