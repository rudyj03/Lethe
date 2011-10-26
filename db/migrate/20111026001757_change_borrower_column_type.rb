class ChangeBorrowerColumnType < ActiveRecord::Migration
  def self.up
    change_column :items, :borrower, :string
  end

  def self.down
  end
end
