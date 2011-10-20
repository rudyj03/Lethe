class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :owner
      t.boolean :loaned
      t.date :expiration

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
