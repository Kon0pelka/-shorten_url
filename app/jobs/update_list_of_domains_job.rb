require 'nokogiri'
require 'open-uri'

class UpdateListOfDomainsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = 'http://data.iana.org/TLD/tlds-alpha-by-domain.txt'
    domains = Nokogiri::HTML(open(url))
    domains = domains.text.split('UTC')[1].split("\n").reject(&:empty?)
    domains.each do |domain|
      Domain.new(name: domain).save
    end
  end
end

# parse http://data.iana.org/TLD/tlds-alpha-by-domain.txt
