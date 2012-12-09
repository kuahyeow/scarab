require 'rubygems'
require 'bundler/setup'

require 'granary'

require 'beetil'

module Scarab
  class Credentials
    attr_reader :beetil_api_token, :harvest_basic, :harvest_subdomain

    def initialize(credentials)
      [:beetil_api_token, :harvest_basic, :harvest_subdomain].each do |key|
        self.instance_variable_set "@#{key}", credentials[key.to_s].to_s
      end
    end
  end
end
