# This migration comes from forest_engine (originally 20170818025229)
class AddBlockLayoutToBlockSlots < ActiveRecord::Migration[5.1]
  def change
    add_reference :block_slots, :block_layout, foreign_key: true, index: true
  end
end
