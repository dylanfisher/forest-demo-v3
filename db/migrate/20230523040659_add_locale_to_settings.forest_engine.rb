# This migration comes from forest_engine (originally 20190702155117)
class AddLocaleToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :locale, :string
    add_index :settings, :locale
  end
end
