class Beer < ActiveRecord::Base
  belongs_to :user
  has_many :reviews

  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true, numericality: true
  validates :brewer, presence: true
  validates :brewing_country, presence: true
  validates :style, presence: true
  validates :abv, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.search(search = nil)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      all
    end
  end
end
