# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'scarab'

credentials = Scarab::Credentials.new(YAML.load File.read('scarab.yml'))

Beetil.configure do |config|
  # Formerly - config.base_url  = "https://youdo.beetil.com/external_api/v1"
  config.base_url = "https://api.gotoassist.com/desk/external_api/v1"
  config.api_token = credentials.beetil_api_token
end

basic = 'Basic ' + credentials.harvest_basic
api = Granary::API.new(:authorization => basic, :subdomain => credentials.harvest_subdomain)


puts "Select start_date (0 to exit): "
(0..6).to_a.reverse.each {|d| puts "[#{d+1}] : " +  (Date.today - d).strftime("%Y-%m-%d %a")}
input = gets.strip
raise "not a valid input" unless %w(0 1 2 3 4 5 6 7 8).include?(input)

case input.to_i
when 0
  exit
when 1, 2, 3, 4, 5, 6, 7, 8
  start_date = Date.today - (input.to_i - 1)
  puts
end


project_id = '718178'           # YouDo Permanent   #TODO extract
from_date = start_date          # Date.civil(2012, 3, 23).strftime("%Y%m%d")
to_date =   Date.today - 1      # yesterday most common case
time_entries = api.project_time(project_id, from_date, to_date)

tt = time_entries.map {|t| Granary::TimeEntry.new t[:day_entry] }
puts tt.map {|t| "#{t.hours} hours spent at #{t.spent_at} with notes #{t.notes}" }

puts "Transmiting to BEETIL...."
tt.each do |t|
  Beetil::TimeEntry.create(:entry => t.notes, :hours => t.hours, :description => t.notes, :performed_at => t.spent_at)
end
puts "DONE"

