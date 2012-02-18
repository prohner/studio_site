class AddStudioIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :studio_id, :integer

  end
end
