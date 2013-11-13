require "spec_helper"

describe WineLinksController do
  describe "routing" do

    it "routes to #index" do
      get("/wine_links").should route_to("wine_links#index")
    end

    it "routes to #new" do
      get("/wine_links/new").should route_to("wine_links#new")
    end

    it "routes to #show" do
      get("/wine_links/1").should route_to("wine_links#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wine_links/1/edit").should route_to("wine_links#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wine_links").should route_to("wine_links#create")
    end

    it "routes to #update" do
      put("/wine_links/1").should route_to("wine_links#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wine_links/1").should route_to("wine_links#destroy", :id => "1")
    end

  end
end
