# app/controllers/playlists_controller.rb
class PlaylistsController < ApplicationController
  def index
    @categories = {}

    if params[:user_code].present? && params[:password].present?
      user_code = params[:user_code]
      password = params[:password]
      playlist_url = "http://85.203.52.33/get.php?username=#{user_code}&password=#{password}&type=m3u_plus&output=ts"

      # Parse the playlist URL and handle any exceptions
      begin
        @categories = M3u8Parser.parse(playlist_url)
        Rails.logger.info("Loaded categories: #{@categories}")
      rescue StandardError => e
        flash[:alert] = "Failed to load playlist: #{e.message}"
      end
    end

    if params[:query].present?
      query = params[:query].downcase
      @categories.each do |category, channels|
        @categories[category] = channels.select { |channel| channel[:title].downcase.include?(query) }
      end
      Rails.logger.info("Filtered categories: #{@categories}")
    end
  end

  def show
    @url = params[:url]
    @channel_name = params[:channel_name]
  end
end

#@categories = M3u8Parser.parse("http://85.203.52.33/get.php?username=#{@user_code}&password=#{@user_code}&type=m3u_plus&output=ts")
