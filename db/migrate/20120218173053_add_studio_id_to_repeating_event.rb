class AddStudioIdToRepeatingEvent < ActiveRecord::Migration
  def change
    add_column :repeating_events, :studio_id, :integer

  end
end
