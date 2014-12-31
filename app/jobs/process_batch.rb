class ProcessBatch
  @queue = :batch_process
  def self.perform(sku_list)
    sku_list.each_with_index do |item, index|
      psku = ProductSku.where(:id => item).first
      product = psku.get_product_detail
      ProductDetail.save_product_details(product)
    end
  end
end
