class ElementFilter
  attr_reader :element

  def initialize(element)
    @element = element
  end

  def create_hash
    {
      href:,
      rel:,
    }
  end

  def href = @element[:href]

  def rel = @element[:rel] ||= "dofollow"
end
