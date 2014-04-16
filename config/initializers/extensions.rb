class Array
  def average
    self.inject(:+) / self.length.to_f
  end

  def pick(key)
    self.inject([]) do |result, elem|
      if elem[key].present?
        result << elem[key]
      else
        result
      end
    end
  end
end
