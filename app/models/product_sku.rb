require "redis"

class ProductSku < ActiveRecord::Base

  validates :sku, :uniqueness => true

  def redis_conn
    Redis.new(:host => '127.0.0.1', :port => 6379)
  end

  def get_url
    record =  redis_conn.hgetall self.sku
    url = record["url"].split(",")[0] rescue nil
  end

  def self.save_data
    ProductSku.all.each_with_index do |item, index|
      urrl = item.get_url
      item.update_column(:url, urrl)
    end
  end

  def get_product_detail
    product = Product.new(sku, url)
  end

  def fetch_product_info
    
  end
  
  
end
