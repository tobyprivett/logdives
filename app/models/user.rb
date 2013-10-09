class User < ActiveRecord::Base
  include Units

  include Humanizer
  attr_accessor :bypass_humanizer
  require_human_on :create, :unless => :bypass_humanizer


  mount_uploader :avatar, AvatarUploader

  has_friendly_id :guid, :use_slug => true

  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  attr_accessible :email, :name, :password, :password_confirmation, :reset_password_token, :remember_me, :name_accessor, :bypass_humanizer, :humanizer_answer, :humanizer_question_id

  has_many :dives, :class_name => "Dive", :foreign_key => "diver_id", :order => 'dives.dive_no desc'
  has_many :buddies, :through => :dives, :order => 'buddies.created_at desc'
  has_many :buddy_confirmations, :class_name => 'Buddy', :order => 'buddies.created_at desc', :foreign_key => 'buddy_diver_id', :conditions => "buddies.state != 'unconfirmed'"

  has_many :user_uploads

  validates_numericality_of :log_start_no, :greater_than_or_equal_to => 1, :message => 'is not valid'
  validates_uniqueness_of :name, :message => "has already been taken"
  validates_presence_of :name
  validates_length_of :name, :within => 4..40
  before_validation :set_name_and_guid

  scope :random, :order=>'RAND()', :limit=>1


  class << self
    def new_with_session(params, session)
        super.tap do |user|
          if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
            user.email = data["email"]
          end
        end
      end

    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token['extra']['user_hash']
      if user = User.find_by_email(data["email"])
        user
      else # Create a user with a stub password.
        user = User.new(:email => data["email"], :password => Devise.friendly_token[0,20], :bypass_humanizer => true)
        user.skip_confirmation!
        user.save!
      end
      user
    end

    def find_or_create_without_password!(email_address)
      ret = User.where(:email => email_address).first
      unless ret
        pwd = ActiveSupport::SecureRandom.base64(6)
        ret = User.new(:email => email_address, :password => pwd, :password_confirmation => pwd,
              :reset_password_token => Devise.friendly_token, :bypass_humanizer => true)
        ret.skip_confirmation!
        ret.save!
      end
      ret
    end
  end

  def new_buddy_requests
      buddy_confirmations.awaiting_confirmation
  end

  def new_buddy_requests_count
    new_buddy_requests.count
  end

  def friends
    buddies.includes(:buddy_diver).map(&:buddy_diver)
  end

  def set_log_start_no!
    i = log_start_no
    dives.order('dive_date, time_in asc').each do |dive|
      dive.update_attribute :dive_no, i
      i += 1
    end
    self.reload
  end

  def name_accessor
    self.name unless (self.name == self.email)
  end

  def name_accessor=(val)
    self.name = val
  end


  protected
  def set_name_and_guid
    self.name ||= self.email
    self.guid ||= UUID.new.to_s
  end

end
