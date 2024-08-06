# app/services/m3u8_parser.rb
class M3u8Parser
  require "httparty"

  def self.parse(url)
    Rails.logger.info("Fetching playlist from URL: #{url}")
    response = HTTParty.get(url).body
    lines = response.split("\n")

    Rails.logger.info("Playlist content: #{lines}")

    categories = Hash.new { |hash, key| hash[key] = [] }
    current_category = "Uncategorized"
    current_title = nil

    lines.each do |line|
      Rails.logger.info("Processing line: #{line}")

      if line.start_with?("#EXTINF")
        info = line.match(/#EXTINF:-1.*tvg-name="(?<name>[^"]*)".*group-title="(?<group>[^"]*)".*,(?<title>.+)/)
        if info
          current_title = info[:name]
          current_category = info[:group]
          Rails.logger.info("Parsed EXTINF - Name: #{current_title}, Group: #{current_category}")
        end
      elsif line.start_with?("http")
        categories[current_category] << { title: current_title || "No Title", url: line }
        current_title = nil
      end
    end

    Rails.logger.info("Parsed categories: #{categories}")
    categories
  rescue StandardError => e
    Rails.logger.error("Failed to parse M3U8: #{e.message}")
    {}
  end
end
