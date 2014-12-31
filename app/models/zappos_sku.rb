class ZapposSku < ActiveRecord::Base

def self.get_sku_from_file
  #file = File.open("/home/rails/rails_work/scrapping/zappos-sku.txt", "r")
  file_arr =  file.readlines.map{|p| p.strip.split(",")}
  file.close
  file_arr.flatten!
  file_arr.each_with_index do |sku, index|
    ZapposSku.create(:sku => sku)
  end
end


def self.save_data
  ZapposSku.all.each_with_index do |item, index|
    ProductSku.create(:sku => item.sku)
  end
end


end
