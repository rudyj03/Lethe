class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :score
  has_many :items, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                  :length   => { :maximum => 50 }
  validates :email, :presence => true,
                    :format =>{:with => email_regex},
                    :uniqueness => {:case_sensitive => false}

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password, :lower_case_email

  def has_password?(submitted_password)
   self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email.downcase)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def to_s
    "#{self.name}, #{self.score}"
  end

  private
   def encrypt_password
     if !password.nil?
       unless has_password?(password)
         self.salt = make_salt
         self.encrypted_password = encrypt(password)
      end
     end
   end

  def lower_case_email
    self.email = email.downcase
  end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
