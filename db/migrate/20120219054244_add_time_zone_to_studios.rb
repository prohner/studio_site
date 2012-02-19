class AddTimeZoneToStudios < ActiveRecord::Migration
  def change
    add_column :studios, :time_zone, :string

  end
end
