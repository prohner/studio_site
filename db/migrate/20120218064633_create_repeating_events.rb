class CreateRepeatingEvents < ActiveRecord::Migration
  def change
    create_table :repeating_events do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :all_day
      t.text :description

      t.string :repetition_type
      t.integer :repetition_frequency

      t.boolean :on_sunday
      t.boolean :on_monday
      t.boolean :on_tuesday
      t.boolean :on_wednesday
      t.boolean :on_thursday
      t.boolean :on_friday
      t.boolean :on_saturday

      t.string :repetition_options

      t.integer :studio_id

      t.timestamps
    end
  end
end
