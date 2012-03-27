class AddLocationAndNotesToRepeatingEvents < ActiveRecord::Migration
  def change
    add_column :repeating_events, :location, :string

    add_column :repeating_events, :notes, :string

  end
end
