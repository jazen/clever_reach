require 'spec_helper'

describe CleverReach::ResponseDecorator do

  let(:subject) { CleverReach::ResponseDecorator }

  let(:body) do
    { :client_get_details_response => {
        :return => {
          :status => "SUCCESS",
          :message => { :"@xsi:type" => "xsd:string" },
          :statuscode => "0",
          :data => {
            :id => "12345",
            :firstname => "Stephan",
            :name => "Schubert",
            :company => "avianta UG",
            :email => "stephan@frozencherry.de",
            :login_domain => "12345.cleverreach.com",
            :item => { :foo => "1", :"@xsi:type" => "foo" },
            :"@xsi:type" => "tns:clientData"
          },
          :"@xsi:type" => "tns:returnClient" },
        :"@xmlns:ns1"=>"CRS"
      }
    }
  end

  it "should delegate missing methods" do
    deco = subject.new(%w(test))
    deco.size.should == 1
  end

  describe "#to_hash" do # ----------------------------------

    it "should return a cleaned hash with just the valuable data" do
      resp = stub(body: body)
      deco = subject.new(resp)

      deco.to_hash.should == {
        id: "12345",
        firstname: "Stephan",
        name: "Schubert",
        company: "avianta UG",
        email: "stephan@frozencherry.de",
        login_domain: "12345.cleverreach.com",
        item: { foo: "1" }
      }
    end

  end

end
