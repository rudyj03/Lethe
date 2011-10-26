class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :items, :owner, :user_id
  end

  def self.down
  end
end
