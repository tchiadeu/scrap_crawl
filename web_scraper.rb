require "open-uri"
require "nokogiri"
require_relative "url_filter"
require_relative "element_filter"

class WebScraper
  attr_reader :url

  def initialize(url, webcrawler)
    @url = url
    @backlinks = webcrawler.backlinks
    @redirections = webcrawler.redirections
  end

  def run
    return if UrlFilter.new(@url).bad_url? || visited?

    exclude_error()
    html_doc = Nokogiri::HTML.parse(@html_file)
    html_doc.search('a').each do |element|
      href = ElementFilter.new(element).href
      next if reject_element?(href)

      if UrlFilter.backlink?(href, @url)
        # puts element.ancestors("nav").first
        @backlinks << ElementFilter.new(element).create_hash(@url) if ElementFilter.new(element).respect_pattern?
      else
        @redirections << { href:, visited: false }
      end
    end
  end

  private

  def exclude_error
    begin
      @html_file = URI.open(@url).read
    rescue OpenURI::HTTPError => e
      return
    end
    @html_file
  end

  def reject_element?(href)
    href.nil? || href == "/" || href.empty? ||
    already_exist?(@backlinks, href) || already_exist?(@redirections, href) ||
    UrlFilter.new(href).rejected_url?
  end

  def visited?
    @redirections.any? { |redirection| redirection[:url] == @url && redirection[:visited] == true }
  end

  def already_exist?(array, href) = array.any? { |element| element[:href] == href }
end
