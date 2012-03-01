class AddColorToRepeatingEvents < ActiveRecord::Migration
  def change
    add_column :repeating_events, :color, :string

  end
end
