class AddImageToStudios < ActiveRecord::Migration
  def change
    add_column :studios, :filename, :string

    add_column :studios, :content_type, :string

    add_column :studios, :data, :binary

  end
end
