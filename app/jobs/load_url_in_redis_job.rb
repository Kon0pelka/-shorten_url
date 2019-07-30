class LoadUrlInRedisJob < ApplicationJob
  queue_as :default

  def perform(*args)
    cache = ActiveSupport::Cache::RedisCacheStore.new(expires_in: 20.minutes)
    Url.all.map do |url|
      cache.write(url.short_url, url.long_url)
    end
  end
end
