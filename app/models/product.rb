require "spreadsheet"
require 'mechanize'
require 'open-uri'

class Product
  attr_accessor :url, :sku, :brand, :product_title, :image_list, :description, :logo, :price, :selected_color, :available_color, :available_size, :width, :star_rating, :review_count, :product_color_variants, :product_color_variant_image_urls 
  def initialize(sku,upath)
    self.sku = sku
    base_url = "http://www.zappos.com"
    self.url = "#{base_url}#{upath}"
    begin
      scrape_page
    rescue Exception => e
    end
  end

  def get_page
    page = Mechanize.new.get(url)
  end

  def scrape_page
    # top level elements
    main_container = get_page.search("#theater")
    centerStage = main_container.search("#centerStage")
    brandLogo = main_container.search("#brandLogo")
    productForm = main_container.search("#productForm")

    # Set SKU number
    #self.sku = main_container.search("#sku").text

    # brand name and product title
    prdImage = centerStage.search("#prdImage")
    self.brand = prdImage.search("h1").search("a")[0].try(:text)
    self.product_title = prdImage.search("h1").search("a")[1].try(:text)

    # star rating and review count
    self.star_rating = prdImage.search("#rating").search("#productReviewsLink > span.rating").try(:text)
    self.review_count =  prdImage.search("#rating").search("#productReviewsLink > em > span[itemprop='reviewCount']").try(:text)
    
    # Set All images
    angles = prdImage.search("#angles-vertical")
    angle_list = angles.search("ul#angles-list a")
    product_images = {}
    angle_list.each_with_index do |node, index|
      large =  "http://www.zappos.com"+node.attributes['href'].value
      temp = {}
      temp["large"] =  large
      temp["medium"] =  large.gsub("4x","MULTIVIEW")
      temp["small"] =  large.gsub("4x","MULTIVIEW_THUMBNAILS")
      product_images[index] = temp
    end
    self.image_list = product_images
    
    # Description
    audience = centerStage.search("#audience > #productDescription > .description")
    description_list = audience.search('div[itemprop="description"] > ul > li')
    self.description = description_list.text

    # Logo
    self.logo = brandLogo.search("h2 > a > img").first['src']

    # Product Form
    form = productForm.search("#purchaseCorner > form")
    self.price = form.search('#priceSlot > .price').try(:text)
    

    # Dimension
    dimensions = form.search("#purchaseOptions > .dimension")
    color_list = dimensions.search('#colors')
    size_list = dimensions.search('#dimension-size')
    
    self.width = dimensions.search('#dimension-width').try(:text)

    # selected color
    color_hash = {}
    self.selected_color =  color_list.search('select option[@selected="selected"]').first.text rescue ""
    
    # Available color
    color_list.search('select option').each do |opt|
      color_hash[opt.attr("value")] = opt.try(:text)
    end
    self.available_color = color_hash
    
    # Available size
    size_hash = {}
    size_list.search('select option').each do |opt|
      size_hash[opt.attr("value")] = opt.try(:text)
    end
    self.available_size =  size_hash

    # product_variants
    product_images = prdImage.search("#productImages > #thumbWrap").search("a")
    if product_images
      varients = {}
      product_images.each do |anchor|
        varients[anchor.attr("data-color")] = anchor.search("img")[0].attr("src")
      end
      self.product_color_variants = varients
    end

    img_list_count = image_list.size.to_i - 1
    variants = {}
    product_color_variants.each do |key, value|
      variant_images = {}
      (0..img_list_count).each_with_index do |item, index|
        tmp = (index == 0)? 'p' : index
        variant_images[index] =  {
                     :large => value.gsub("p-MOBILETHUMB","#{tmp}-4x"),
                     :medium => value.gsub("p-MOBILETHUMB","#{tmp}-MULTIVIEW"),
                     :small => value.gsub("p-MOBILETHUMB","#{tmp}-MULTIVIEW_THUMBNAILS")
                    }
      end
      variants[key] = variant_images
    end
    self.product_color_variant_image_urls = variants
    
  end
  
end




