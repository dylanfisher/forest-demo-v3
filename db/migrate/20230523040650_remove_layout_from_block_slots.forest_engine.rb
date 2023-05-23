# This migration comes from forest_engine (originally 20170818025500)
class RemoveLayoutFromBlockSlots < ActiveRecord::Migration[5.1]
  def change
    remove_column :block_slots, :layout, :string
  end
end
