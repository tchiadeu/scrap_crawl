require_relative "web_scraper"

class WebCrawler
  attr_reader :url
  attr_accessor :redirections, :backlinks

  def initialize(url, objective)
    @url = url
    @count = 0
    @objective = objective
    @redirections = []
    @backlinks = []
    @webcrawler = self
  end

  def run
    puts "--------------------------------------"
    start_time = Time.now
    puts "Start Time: #{start_time}"
    while @count < @objective || (@redirections.any? { |redirection| redirection[:visited] == false })
      break if @count >= @objective

      if @redirections.empty?
        WebScraper.new(@url, @webcrawler).run
        @count += 1
      else
        @redirections.each do |redirection|
          next if redirection[:visited]
          break if @count >= @objective

          WebScraper.new(redirection[:href], @webcrawler).run
          redirection[:visited] = true
          @count += 1
          if @count % 20 == 0
            puts "--------------------------------------"
            puts "Visited: #{@count} / #{@objective}"
          end
        end
      end
    end
    puts "--------------------------------------"
    end_time = Time.now
    puts "End Time: #{end_time}"
    puts "--------------------------------------"
    puts "Total Time: #{(end_time - start_time) > 60 ? "#{(end_time - start_time) / 60} minutes" : "#{end_time - start_time} seconds"}"
    puts "--------------------------------------"
    puts "Redirections not visited: #{@redirections.select { |redirection| redirection[:visited] == false }.count}"
    puts "--------------------------------------"
    puts "Backlinks (#{@backlinks.count}): #{@backlinks}"
    puts "--------------------------------------"
  end
end

puts "Enter the url you want to crawl:"
url = gets.chomp
puts "Enter the number of pages to scrap:"
objective = gets.chomp.to_i
WebCrawler.new(url, objective).run
# WebCrawler.new("https://forum.parents.fr/", 1).run
# WebCrawler.new("https://www.les-astucieux.com/enlever-une-tache-de-sang/?unapproved=24462&moderation-hash=0f1e800358bd6c8b4edc94880acd9dea#comment-24462", 1000).run
# WebCrawler.new("https://www.les-astucieux.com/", objective).run
# WebCrawler.new("https://www.rubydoc.info/gems/capybara/Capybara%2FNode%2FFinders:ancestor", 40).run
