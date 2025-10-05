class BaseService
  Result = Struct.new(:success?, :data, :error)

  def self.call(*args)
    new(*args).call
  end
end
