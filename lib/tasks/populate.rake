namespace :db do
  desc "scrape and fill database"
  task :populate => :environment do
    sku_list = ProductSku.order("id asc").limit(100).offset(0)
    sku_list.each_with_index do |item, index|
      product = item.get_product_detail
      ProductDetail.save_product_details(product)
      puts "===============================#{index}"
    end
  end
end
