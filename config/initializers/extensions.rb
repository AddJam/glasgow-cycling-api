class Array
  def average
    self.inject(0) do |total, elem|
      total += elem || 0
    end / self.length.to_f
  end

  def pick(key)
    self.inject([]) do |result, elem|
      result << elem[key] if elem[key].present?
      result
    end
  end
end
