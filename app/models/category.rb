# app/models/category.rb
class Category < ApplicationRecord
  has_many :channels, dependent: :destroy
end

# app/models/channel.rb
class Channel < ApplicationRecord
  belongs_to :category
end
