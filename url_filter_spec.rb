require "rspec"
require_relative "url_filter"

describe UrlFilter do
  before do
    @url = "https://www.google.com"
    @object = UrlFilter.new(@url)
  end
  context "not give an url to the class" do
    it "shouldn't be a valid record" do
      expect { UrlFilter.new }.to raise_error(ArgumentError)
    end
  end
  context "give an url to the class" do
    it "should be a valid record" do
      expect { UrlFilter.new(@url) }.not_to raise_error
    end
  end
  context "#url_filter" do
    it "should filter the url without the http" do
      expect(@object.send(:filter)).to eq("www.google.com")
    end
  end
  context "#start_with_http?" do
    it "should return true if the url start with http" do
      expect(@object.send(:start_with_http?)).to be_truthy
    end
    it "should return false if the url doesn't start with http" do
      other_object = UrlFilter.new("www.google.com")
      expect(other_object.send(:start_with_http?)).to be_falsey
    end
  end
  context "#start_with_www?" do
    it "should return true if the url start with www" do
      object_one = UrlFilter.new("www.google.com")
      object_two = UrlFilter.new("/www.google.com")
      object_three = UrlFilter.new("//www.google.com")
      expect(object_one.send(:start_with_www?)).to be_truthy
      expect(object_two.send(:start_with_www?)).to be_truthy
      expect(object_three.send(:start_with_www?)).to be_truthy
    end
    it "should return false if the url doesn't start with www" do
      expect(@object.send(:start_with_www?)).to be_falsey
    end
  end
  context "#domain" do
    it "should return the domain of the url" do
      expect(@object.send(:domain)).to eq({ root: "www.google.com", value: "google" })
    end
  end
  context "#domain_possibilites" do
    it "should return the possibilities of the domain" do
      expect(@object.send(:domain_possibilities)).to eq (%w[www google com])
    end
  end
  context "#self.same_domain?" do
    it "should return true if the domain is the same" do
      google_url = "https://www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8"
      expect(UrlFilter.same_domain?(google_url, @url)).to be_truthy
    end
    it "should return false if the domain is different" do
      github_url = "https://github.com/dashboard"
      expect(UrlFilter.same_domain?(github_url, @url)).to be_falsey
    end
  end
  context "#bad_url?" do
    it "should return false if the url is valid" do
      expect(@object.bad_url?).to be_falsey
    end
    it "should return true if the url is invalid" do
      object = UrlFilter.new("www.google")
      expect(object.bad_url?).to be_truthy
    end
  end
  context "#transform_without_http" do
    it "should return the url without http" do
      expect(@object.transform_without_http).to eq("www.google.com")
    end
  end
  context "#self.backlink?" do
    it "should return true if the url start with http and the domain is different" do
      github_url = "https://github.com/dashboard"
      expect(UrlFilter.backlink?(github_url, @url)).to be_truthy
    end
    it "should return true if the url start with www" do
      github_url = "www.github.com/dashboard"
      expect(UrlFilter.backlink?(github_url, @url)).to be_truthy
    end
  end
  context "#url_formated" do
    google_http = "https://www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8"
    http_object = UrlFilter.new(google_http)
    google_www = "www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8"
    www_object = UrlFilter.new(google_www)
    without_domain = "search?q=rspec+google&sourceid=chrome&ie=UTF-8"
    last_object = UrlFilter.new(without_domain)
    it "should return the url formated" do
      expect(http_object.url_formated(@url)).to eq("https://www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8")
      expect(www_object.url_formated(@url)).to eq("www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8")
      expect(last_object.url_formated(@url)).to eq("www.google.com/search?q=rspec+google&sourceid=chrome&ie=UTF-8")
    end
  end
  context "#start_with_hashtag?" do
    it "should return true if the url start with #" do
      url = "#test"
      object = UrlFilter.new(url)
      expect(object.send(:start_with_hashtag?)).to be_truthy
    end
  end
  context "#social_url?" do
    it "should return true if the url start with #" do
      url = "www.facebook.com"
      object = UrlFilter.new(url)
      expect(object.social_url?).to be_truthy
    end
  end
  context "#rejected_url?" do
    it "should return true if the url is rejected" do
      url_one = "#test"
      url_two = "www.facebook.com"
      url_three = "www.google.com"
      expect(UrlFilter.new(url_one).rejected_url?).to be_truthy
      expect(UrlFilter.new(url_two).rejected_url?).to be_truthy
      expect(UrlFilter.new(url_three).rejected_url?).to be_truthy
    end
  end
end
