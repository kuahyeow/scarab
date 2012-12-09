require 'rubygems'
require 'bundler/setup'

require 'granary'

require 'beetil'

module Scarab
  class Credentials
    attr_reader :beetil_api_token, :harvest_basic, :harvest_subdomain
    attr_reader :harvest_project_id

    def initialize(credentials)
      [:beetil_api_token, :harvest_basic, :harvest_subdomain].each do |key|
        self.instance_variable_set "@#{key}", credentials[key.to_s].to_s
      end
      @harvest_project_id = credentials['harvest_project_id'].to_s
    end
  end
end
