class UrlFilter
  attr_reader :url
  SOCIALS = %w[facebook twitter linkedin instagram medium pinterest snapchat github youtube whatsapp skype discord twitch tiktok google apple amazon telegram]

  def initialize(url)
    @url = url
  end

  def rejected_url?
    start_with_hashtag? || social_url?
  end

  def self.same_domain?(url_to_control, start_url)
    UrlFilter.new(url_to_control).domain_possibilities.include?(UrlFilter.new(start_url).domain[:value])
  end

  def self.backlink?(url_to_control, start_url)
    (UrlFilter.new(url_to_control).start_with_http? && !UrlFilter.same_domain?(url_to_control, start_url)) ||
    (UrlFilter.new(url_to_control).start_with_www? && !UrlFilter.same_domain?(url_to_control, start_url))
  end

  def self.redirection?(url_to_control, start_url)

  end

  def bad_url?
    regexp = /^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/
    @url.match?(regexp) == false
  end

  def transform_without_http
    regexp = /https?:\/\//
    @url.gsub(regexp, "")
  end

  def url_formated(start_url)
    (UrlFilter.new(@url).start_with_http? || UrlFilter.new(@url).start_with_www?) ? @url : "#{UrlFilter.new(start_url).domain[:root]}/#{@url}"
  end

  def domain_possibilities = filter.split("/").first.split(".")

  def domain
    root = filter.split("/").first
    value = %w[www forum blog].include?(root.split(".").first) ? root.split(".")[1] : root.split(".").first
    { root:, value: }
  end

  def start_with_http? = @url.start_with?("http")

  def start_with_www? = @url.split("/").reject(&:empty?).first.start_with?("www")

  def start_with_hashtag? = @url.start_with?("#")

  def social_url?
    SOCIALS.include?(UrlFilter.new(url).domain[:value])
  end

  def filter
    regexp = /https?:\/\//
    @url.gsub(regexp, "")
  end
end
