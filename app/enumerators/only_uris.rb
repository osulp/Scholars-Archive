##
# An enumerator which iterates only over URIs in a given set of values.
class OnlyUris
  attr_reader :values
  delegate :length, :to => :to_a
  include Enumerable
  def initialize(values)
    @values = Array.wrap(values)
  end

  def each
    values.each do |value|
      if uri?(value)
        yield value
      end
    end
  end

  private

  def uri?(value)
    MaybeURI.new(value).uri?
  end
end
