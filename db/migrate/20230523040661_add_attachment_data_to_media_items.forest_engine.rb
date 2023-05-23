# This migration comes from forest_engine (originally 20200703180410)
class AddAttachmentDataToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :attachment_data, :jsonb
  end
end
