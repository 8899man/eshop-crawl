require "spec_helper"

describe UserMailer do
  describe "cheap" do
    let(:mail) { UserMailer.cheap }

    it "renders the headers" do
      mail.subject.should eq("Cheap")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
