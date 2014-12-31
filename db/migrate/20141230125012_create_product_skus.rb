class CreateProductSkus < ActiveRecord::Migration
  def change
    create_table :product_skus do |t|
      t.string :sku
      t.string :url
      t.timestamps
    end
  end
end
