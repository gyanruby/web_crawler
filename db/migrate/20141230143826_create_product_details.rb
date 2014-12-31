class CreateProductDetails < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.string :url
      t.string :sku
      t.string :brand
      t.string :product_title
      t.text :image_list
      t.text :description
      t.string :logo
      t.string :price
      t.text :selected_color
      t.text :available_color
      t.text :available_size
      t.string :width
      t.string :star_rating
      t.string :review_count
      t.text :product_color_variants
      t.text :product_color_variant_image_urls 

      t.timestamps
    end
  end
end

