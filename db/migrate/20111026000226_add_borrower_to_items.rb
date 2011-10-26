class AddBorrowerToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :borrower, :string
  end

  def self.down
    remove_column :items, :borrower
  end
end
