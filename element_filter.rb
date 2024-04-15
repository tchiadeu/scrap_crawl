class ElementFilter
  attr_reader :element

  def initialize(element)
    @element = element
  end

  def respect_pattern?
    !nav?
  end

  def create_hash(page)
    {
      href:,
      rel:,
      page:
    }
  end

  def href = @element[:href]

  def rel = @element[:rel] ||= "dofollow"

  def nav? = !@element.ancestors("nav").first.nil?
end
