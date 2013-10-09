class Buddy < ActiveRecord::Base
  include AASM
  has_friendly_id :guid, :use_slug => true

  validates_presence_of :guid
  validates_presence_of :dive_id, :unless => :nested

  before_validation :set_guid
  validates_with BuddyValidator

  attr_accessor :nested, :buddy_diver_name_accessor
  belongs_to :dive
  belongs_to :buddy_diver, :class_name => "User", :foreign_key => "buddy_diver_id"
  belongs_to :reciprocal_dive, :class_name => "Dive", :foreign_key => "reciprocal_dive_id"
  validates_uniqueness_of :buddy_diver_id, :scope => :dive_id

  aasm_column :state
  aasm_initial_state :unconfirmed
  aasm_state :unconfirmed
  aasm_state :awaiting_confirmation, :enter => :send_confirmation_request
  aasm_state :confirmed
  aasm_state :rejected


  aasm_event :request_confirmation! do
    transitions :to => :awaiting_confirmation, :from => [:unconfirmed], :guard => :diver_present?
  end

  aasm_event :confirm! do
    transitions :to => :confirmed, :from => [:unconfirmed, :awaiting_confirmation, :rejected]
  end

  aasm_event :reject! do
    transitions :to => :rejected, :from => [:awaiting_confirmation]
  end



  def diver
    self.dive.diver if self.dive
  end


  def diver_name
    return '' unless self.diver
    diver.name
  end

  def diver_present?
    self.buddy_diver
  end

  def role_s
    self.role.present? ? self.role : 'Buddy'
  end


  def buddy_diver_name=val
    if val =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
      self.buddy_diver = User.find_or_create_without_password!(val)
    else
      self.buddy_diver = User.find_by_name(val)
    end
  end

  def buddy_diver_name
    return unless buddy_diver
    buddy_diver.name
  end

  def send_confirmation_request
    return if self.buddy_diver.last_request_emailed_at && (self.buddy_diver.last_request_emailed_at  > 24.hours.ago)
    Notifier.request_confirmation_from_buddy(self).deliver
    buddy_diver.update_attribute :last_request_emailed_at, Time.now
    true
  end


  class << self
    def actionable
      where(:state != 'unconfirmed')
    end

    def eagerly
      includes({:dive => [:diver, :slug]}, {:reciprocal_dive => [:slug]}, :slug)
    end
  end

  protected

  def set_guid
    self.guid ||= UUID.new.to_s
  end
end
