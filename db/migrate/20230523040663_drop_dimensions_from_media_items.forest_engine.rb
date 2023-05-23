# This migration comes from forest_engine (originally 20200815160315)
class DropDimensionsFromMediaItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :media_items, :dimensions, :text
  end
end
