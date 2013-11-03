require 'spec_helper'

describe WineMonitorsCell do

  context "cell instance" do
    subject { cell(:wine_monitors) }

    it { should respond_to(:categories) }
  end

  context "cell rendering" do
    context "rendering categories" do
      subject { render_cell(:wine_monitors, :categories) }

      it { should have_selector("h1", :content => "WineMonitors#categories") }
      it { should have_selector("p", :content => "Find me in app/cells/wine_monitors/categories.html") }
    end
  end

end
