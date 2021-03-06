require 'spec_helper'

describe CleverReach::ResponseDecorator do

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

  let(:response) { stub(body: body) }
  let(:subject)  { CleverReach::ResponseDecorator.new(response) }

  describe "Method Delegation" do # ------------------------
    let(:response) { stub(body: body, foo: 1) }

    it "should check the underlying object" do
      subject.foo.should == 1
    end
  end

  describe "#to_hash" do # ----------------------------------

    it "should return a cleaned hash with just the valuable data" do
      subject.to_hash.should == {
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

  describe "Response w/o errors" do # ----------------------
    it { should be_valid }

    it "should have status code 0" do
      subject.status_code.should be_zero
    end
  end

  describe "Response w/ errors" do # -----------------------
    let(:body) do
      { :some_method_response => {
          :return => { :status => 'ERROR', :statuscode => '40' }
        }
      }
    end

    it { should_not be_valid }

    it "should have a non-zero status code" do
      subject.status_code.should_not be_zero
    end
  end

end
