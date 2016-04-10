class User < ActiveRecord::Base
  include BCrypt

  has_secure_password

  validates :fullname, :length => {minimum: 3, maximum: 130}
  validates :email, :length => {minimum: 2, maximum: 100}, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates_uniqueness_of :email
  validates :password, :length => {minimum: 6, maximum: 24}, :if => :password_changing?
  validates :password, confirmation: true, :if => :password_changing?

  # Image
  has_attached_file :photo, styles: {medium: "150x150>", thumb: "40x40>"}, default_url: "/system/photo/:style/unknown-person.gif", :processors => [:cropper]
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/jpg', 'image/png']
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def password_changing?
    !password.nil?
  end

  def email_changing? new_email
    if email != new_email
      # Ops, e-mail changed
      generate_email_auth_key # Generate new key
      self.email_token_valid = false # Cancel access
      return true
    else
      return false
    end
  end

  def generate_email_auth_key
    self.email_token = SecureRandom.hex(50) # Generate token for e-mail validation
  end

  def self.count_activated
    User.where(:activated => true).count
  end

  def self.list_all page, per_page, search
    if page.nil? && search.nil?
      User.order(:fullname => :asc)
    else
      if search.nil?
        User.order(:fullname => :asc).paginate(:page => page, :per_page => per_page)
      else
        User.where("fullname ILIKE ? OR email ILIKE ?", "%#{search}%", "%#{search}%").order(:fullname => :asc).paginate(:page => page, :per_page => per_page)
      end
    end
  end
end