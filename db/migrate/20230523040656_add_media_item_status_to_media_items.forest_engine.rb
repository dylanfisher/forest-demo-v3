# This migration comes from forest_engine (originally 20180712162414)
class AddMediaItemStatusToMediaItems < ActiveRecord::Migration[5.1]
  def change
    add_column :media_items, :media_item_status, :integer, default: 0
    add_index :media_items, :media_item_status
  end
end
