class AddNameTranslatedToTermGroup < ActiveRecord::Migration
  def change
    add_column :term_groups, :name_translated, :string

  end
end
