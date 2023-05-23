# This migration comes from forest_engine (originally 20200815173949)
class AddAttachmentContentTypeToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :media_items, :attachment_content_type, :string
    add_index :media_items, :attachment_content_type
  end
end
