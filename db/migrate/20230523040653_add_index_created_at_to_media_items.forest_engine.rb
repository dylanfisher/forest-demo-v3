# This migration comes from forest_engine (originally 20180618190248)
class AddIndexCreatedAtToMediaItems < ActiveRecord::Migration[5.2]
  def change
    add_index :media_items, :created_at
  end
end
