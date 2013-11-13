require "spec_helper"

describe User::WineLinksController do
  describe "routing" do

    it "routes to #index" do
      get("/user/wine_links").should route_to("user/wine_links#index")
    end

    it "routes to #new" do
      get("/user/wine_links/new").should route_to("user/wine_links#new")
    end

    it "routes to #show" do
      get("/user/wine_links/1").should route_to("user/wine_links#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user/wine_links/1/edit").should route_to("user/wine_links#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user/wine_links").should route_to("user/wine_links#create")
    end

    it "routes to #update" do
      put("/user/wine_links/1").should route_to("user/wine_links#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user/wine_links/1").should route_to("user/wine_links#destroy", :id => "1")
    end

  end
end
