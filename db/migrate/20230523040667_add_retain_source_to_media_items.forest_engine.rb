# This migration comes from forest_engine (originally 20210622184615)
class AddRetainSourceToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :retain_source, :boolean, default: false, null: false
  end
end
