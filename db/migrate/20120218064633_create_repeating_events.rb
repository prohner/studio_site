class CreateRepeatingEvents < ActiveRecord::Migration
  def change
    create_table :repeating_events do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :all_day
      t.text :description
      t.integer :repetition_frequency
      t.string :repetition_options

      t.timestamps
    end
  end
end
