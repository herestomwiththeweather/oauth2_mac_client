require 'spec_helper'

module Oauth2MacClient
  describe Token do
    let :token do
      Token.new(
        :access_token => 'access_token',
        :mac_key => 'secret',
        :mac_algorithm => 'hmac-sha-256',
        :issued_at => issued_at
    )
    end

    let(:issued_at) { 1305820455 }
    subject { token }

    its(:mac_key)    { should == 'secret' }
    its(:mac_algorithm) { should == 'hmac-sha-256' }

    describe '.calculate_hmac' do
      it "produces the hmac expected from the spec" do
        @token = Token.new(:access_token => 'abc',:mac_key => '8yfrufh348h',:mac_algorithm => 'hmac-sha-1')
        @token.nonce = '273156:di3hvdf8'
        @token.method = 'POST'
        @token.request_uri = '/request'
        @token.host = 'example.com'
        @token.port = 80
        @token.body_hash = 'k9kbtCIy0CkI3/FEfpS/oIDjk6k='
        @token.calculate_hmac.should == 'W7bdMZbv9UWOTadASIQHagZyirA='
      end
    end
  end
end
