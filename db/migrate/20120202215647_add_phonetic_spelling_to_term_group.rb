class AddPhoneticSpellingToTermGroup < ActiveRecord::Migration
  def change
    add_column :term_groups, :phonetic_spelling, :string

  end
end
