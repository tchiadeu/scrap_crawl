require "open-uri"
require "nokogiri"
require_relative "url_filter"
require_relative "element_filter"

class WebScraper
  attr_reader :url
  attr_accessor :backlinks, :redirections

  def initialize(url)
    @url = url
    @backlinks = []
    @redirections = []
  end

  def run
    return if UrlFilter.new(@url).bad_url? || visited?

    exclude_error()
    html_doc = Nokogiri::HTML.parse(@html_file)
    html_doc.search('a').each do |element|
      href = ElementFilter.new(element).href
      next if reject_element?(href)

      puts href

      # @backlinks << ElementFilter.new(element).create_hash if UrlFilter.backlink?(href, @url)
      # @redirections << { href:, visited: false } if UrlFilter.redirection?(href, @url)
    end
    # puts "Backlinks: #{@backlinks}"
    # puts "----------------------------------"
    # puts "Redirections: #{@redirections}"
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
    href.nil? ||
    already_exist?(@backlinks, href) ||
    already_exist?(@redirections, href) ||
    UrlFilter.new(href).rejected_url?
  end

  def visited?
    @redirections.any? { |redirection| redirection[:url] == @url && redirection[:visited] == true }
  end

  def already_exist?(array, href) = array.any? { |element| element[:href] == href }
end


WebScraper.new("https://www.les-astucieux.com/").run
# WebScraper.new("https://forum.parents.fr/").run
# WebScraper.new("https://www.les-astucieux.com/enlever-une-tache-de-sang/?unapproved=24462&moderation-hash=0f1e800358bd6c8b4edc94880acd9dea#comment-24462").run
