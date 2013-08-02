class User < ActiveRecord::Base
  belongs_to :company
  has_many :orders
  has_many :cards
  has_and_belongs_to_many :gyms
  has_and_belongs_to_many :bookmarked_gyms, join_table: 'gym_bookmarks', class_name: 'Gym'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :role, :roles, :email, :password, :password_confirmation, :remember_me, :mobile, :name, :login_name, :gym_ids, :company_id
  attr_accessor :role
  attr_accessor :login

  validates :mobile, :name, presence: true
  validates :login_name, presence: true, uniqueness: { case_sensitive: false }
  validates :mobile, uniqueness: true, length: { is: 11 }, numericality: true

  scope :mobile_verified, lambda { where("mobile_verified_at is not null") }
  scope :as_role, lambda { |role| where("#{table_name}.roles_mask & #{ROLES.index(role).nil? ? 0 : (2**ROLES.index(role))}") }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  ROLES = %w[admin manager leader]

  def display_name
    name || login_name || email
  end

  def role=(role)
    return if role.to_s == 'admin'
    
    @role = role
    self.roles = [role.to_s]
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def backend?
    is?(:admin) || is?(:manager) || is?(:leader)
  end

  before_create :set_default_role
  before_save :check_mobile_changed

  def mobile_verified?
    mobile_verified_at.present?
  end

  def verify_mobile(code)
    if (!code.blank?) && (!mobile_verified?) && self.mobile_verification_code == code
      self.mobile_verified_at = Time.now
      save
    end
    after_mobile_verified
    mobile_verified?
  end

  def send_mobile_verification_sms
    if !mobile_verified? && mobile.present? && mobile_verification_code.present?
      SMSGateway.render_then_send(mobile, 'verify_mobile', { mobile_verification_code: mobile_verification_code })
    end
  end

  def bookmark(gym)
    unless self.bookmarked_gyms.include?(gym)
      self.bookmarked_gyms << gym
    end
  end

  def unbookmark(gym)
    if self.bookmarked_gyms.include?(gym)
      self.bookmarked_gyms.delete(gym)
    end
  end

  protected

  def set_default_role
    if User.count == 0
      self.roles = ['admin']
    end
  end

  def check_mobile_changed
    if mobile_changed? && mobile.present?
      generate_mobile_verification_code
    end
  end

  def generate_mobile_verification_code
    if mobile.present?
      self.mobile_verified_at = nil
      self.mobile_verification_code = "#{Array.new(6){rand(9)}.join}"
      send_mobile_verification_sms
    end
  end

  def after_mobile_verified
    if mobile_verified?
      add_cards_according_to_mobile
    end
  end

  def add_cards_according_to_mobile
    Card.all.each do |c|
      if c.user.blank? && c.mobile == self.mobile
        c.user = self
        c.save
      end
    end
  end
end
