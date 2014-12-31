class CreateBatch
  @queue = :batch_creator
  def self.perform()
    ProductSku.find_in_batches(:batch_size => 1000) do |group|
      Resque.enqueue(ProcessBatch, group.map(&:id))
    end
  end
end
