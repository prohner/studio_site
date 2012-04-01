class DropImageNameFromTerms < ActiveRecord::Migration
  def up
    remove_column :terms, :image_name
    add_column :terms, :filename, :string
    add_column :terms, :content_type, :string
    add_column :terms, :data, :binary
  end

  def down
    add_column :terms, :image_name, :string
    remove_column :terms, :filename
    remove_column :terms, :content_type
    remove_column :terms, :data
  end
end
