class UrlsController < ApplicationController
  def get_url
    cache = ActiveSupport::Cache::RedisCacheStore.new
    ret_url = cache.read(params[:id])
    render json: { url: ret_url }, status: 200
  end

  def set_url
    long_url = params[:url]
    if check_url
      short_url = Url.new(long_url: long_url, short_url: SecureRandom.hex(3))
      if short_url.save
        LoadUrlInRedisJob.perform_now
        render json: { short_url: generate_url + short_url.short_url }, status: 200
      else
        render status: 400
      end
    else
      render json: { short_url: generate_url + find_short_url.short_url }, status: 200
    end
  end

  private

  def check_url
    find_short_url.nil?
  end

  def generate_url
    ENV['site_url'] + '/'
  end

  def find_short_url
    Url.find_by(long_url: params[:url])
  end
end
