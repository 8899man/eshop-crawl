require 'spec_helper'

describe "User::WineLinks" do
  describe "GET /user_wine_links" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_wine_links_path
      response.status.should be(200)
    end
  end
end