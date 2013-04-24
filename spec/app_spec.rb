require 'spec_helper'

describe "Ruby URL Shortener" do

  describe "POST link to shorten" do
    it "creates a new link entry" do
      expect {
        post "/", link: { url: "http://wp.pl" }
      }.to change{Link.count}.by(1)
    end
  end

  describe "GET shroten URL" do
    before { create_link }

    it "redirects to original URL" do
      get "/#{@code}"
      last_response.status.should == 302
      last_response.headers["location"].should == "http://wp.pl/"
    end

    it "records a new view when a URL is requested" do
      expect { get "/#{@code}" }.to change{View.count}.by(1)
    end

    it "unrecognised path returns 404" do
      get "/foo/bar"
      last_response.status.should == 404
    end
  end

  describe "GET shorten URL stats" do
    before { create_link }

    it "redirect to root if token is wrong" do
      get "/#{@code}/stats"
      last_response.should be_redirect
      last_response.location.should == 'http://localhost:4567'
    end

    it "shows stats token is correct" do
      get "/#{@code}" # create view

      get "/#{@code}/stats", token: 'test_token'
      last_response.should_not be_redirect
      last_response.body.should include 'Browser views'
    end
  end

end

def create_link(url = "http://wp.pl/")
  @url = url
  link = Link.create(url: @url, token: "test_token")
  @code = link.code
end
