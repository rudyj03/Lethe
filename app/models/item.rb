class Item < ActiveRecord::Base
  attr_accessible :description, :loaned, :expiration, :borrower
  belongs_to :user

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :description, :presence => true, :length => {:maximum => 50}
  validates :user_id, :presence => true
  validates :borrower, :allow_blank => true,:format =>{:with => email_regex}
  validate :expiration_date_cannot_be_in_the_past

  before_save :lower_case_email

  def expiration_date_cannot_be_in_the_past
    if !expiration.blank? and expiration < Date.today
      errors.add(:expiration, "can't be in the past")
    end
  end

  def lower_case_email
    self.borrower = borrower.downcase
  end

end
