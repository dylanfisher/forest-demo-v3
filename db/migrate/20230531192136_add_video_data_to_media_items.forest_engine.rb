# This migration comes from forest_engine (originally 20230531192056)
class AddVideoDataToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :video_data, :jsonb
  end
end
