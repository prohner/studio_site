class AddImageNameToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :image_name, :string

  end
end
