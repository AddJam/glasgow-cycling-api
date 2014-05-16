class Array
  def sum
    self.inject(0) do |total, elem|
      total += elem || 0
    end
  end

  def average
    sum / self.length.to_f
  end

  def pick(key)
    self.inject([]) do |result, elem|
      if elem.is_a? Hash
        result << elem[key] if elem[key].present?
      elsif elem.is_a? Object
        data = elem.send(key)
        result << data if data.present?
      end
      result
    end
  end
end
