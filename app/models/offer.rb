class Offer < ActiveRecord::Base
  belongs_to :business

  has_many :time_windows
  has_many :impressions
  has_many :clicks
  has_many :conversions

  validates :users_time_availablity, presence: true
  validates :available_from, presence: true
  validates :available_to, presence: true
  validates :price, presence: true
  validates :product, presence: true
  validates :product_description, presence: true

  has_attached_file :avatar, styles: {
    large: "500x500>", medium: "300x300>", thumb: "100x100>"
  }

  def active?
    Time.now < self.available_to and Time.now > self.available_from
  end

  def el

    timewindow = TimeWindow.where(user_id: current_customer.id).where(offer_id: self.id)
  end

  def current_offer
    self.time_windows.any? { |t| (t.end_time < Time.now) ? true : false }
  end

  def eligible_for?(user)
    window = self.time_windows.find_by(user: user)

    if active?
      return true if window.nil?
      (window.end_time > Time.now)
    else
      return false
    end

  end

end
