class CreateZapposSkus < ActiveRecord::Migration
  def change
    create_table :zappos_skus do |t|
      t.string :sku
      t.string :url
      t.timestamps
    end
  end
end
