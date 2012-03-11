require "oauth2_mac_client/version"
require "active_support/core_ext"

module Oauth2MacClient
  class Token
    attr_accessor :access_token, :mac_key, :mac_algorithm, :issued_at
    attr_accessor :method, :request_uri, :host, :port, :body_hash
    attr_writer :nonce

    def initialize(attributes={})
      @access_token = attributes[:access_token]
      @mac_key = attributes[:mac_key]
      @mac_algorithm = attributes[:mac_algorithm]
      @issued_at = attributes[:issued_at] || Time.now.utc
    end

    def age
      age = Time.now.utc - @issued_at
      age.to_i
    end

    def nonce
      @nonce ||= [
        age,
        SecureRandom.hex
      ].join(':')
    end

    def request_string
      [nonce,
       @method,
       @request_uri,
       @host,
       @port,
       @body_hash,
       '', # ext
       nil].join("\n")
    end

    def base64_encode(text)
      Base64.encode64(text).gsub(/\n/,'')
    end

    def openssl_digest
      @openssl_digest ||= case @mac_algorithm
                          when 'hmac-sha-256' then OpenSSL::Digest::SHA256.new
                          when 'hmac-sha-1' then OpenSSL::Digest::SHA1.new
                          end
    end

    def calculate_hmac
      result = OpenSSL::HMAC.digest(openssl_digest,@mac_key,request_string)
      base64_encode result
    end

    def construct_authorization_header(url,method,body="")
      @body_hash = body.empty? ? "" : body_hash(body)
      @method=method.upcase
      uri = URI.parse(url)
      @host=uri.host
      @port=uri.port
      @request_uri=uri.request_uri
      @hmac=calculate_hmac
      authorization_header
    end

    def authorization_header
      header = "MAC"
      header << " id=\"#{@access_token}\","
      header << " nonce=\"#{nonce}\","
      header << " bodyhash=\"#{@body_hash}\","
      header << " mac=\"#{@hmac}\","
    end

    def body_hash(body)
      result = openssl_digest.digest(body)
      base64_encode result
    end
  end
end
