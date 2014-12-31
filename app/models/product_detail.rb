
class ProductDetail < ActiveRecord::Base
  serialize :image_list, Hash
  serialize :available_color, Hash
  serialize :available_size, Hash
  serialize :product_color_variants, Hash
  serialize :product_color_variant_image_urls, Hash

  
  def ProductDetail.save_product_details(product)
    ProductDetail.create({
      :url => product.url,
      :sku => product.sku,
      :brand => product.brand,
      :product_title => product.product_title,
      :image_list => product.image_list,
      :description => product.description,
      :logo => product.logo,
      :price => product.price,
      :selected_color => product.selected_color,
      :available_color =>  product.available_color,
      :available_size => product.available_size,
      :width => product.width,
      :star_rating =>  product.star_rating,
      :review_count =>  product.review_count,
      :product_color_variants =>  product.product_color_variants,
      :product_color_variant_image_urls => product.product_color_variant_image_urls
    }) unless product.blank?
  end 
end
