class AddLocationAndNotesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location, :string

    add_column :events, :notes, :string

  end
end
