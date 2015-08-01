class User < ActiveRecord::Base
  include UUID, AASM
  has_many :behaviors
  has_many :verification_codes
  has_many :demanded_tasks, foreign_key: 'demander_id', class_name: 'Task'
  has_many :supplied_tasks, foreign_key: 'supplier_id', class_name: 'Task'
  mount_uploader :portrait, UserPortraitUploader
  aasm column: 'state' do
    state :unactivated, initial: true
    state :activated
    state :prohibited
    event :active do
      transitions from: :unactivated, to: :activated
    end
  end

  def sign_up options = {}
    ActiveRecord::Base.transaction do
      raise InvalidState.new unless self.unactivated?
      raise DuplicatedPhone.new if User.phone_exist?(options[:phone])
      raise DuplicatedNickname.new if User.nickname_exist?(options[:nickname])
      VerificationCode.validate_sign_up(user: self, phone: options[:phone], verification_code: options[:verification_code])
      update!(phone: options[:phone], nickname: options[:nickname])
      self.active!
      self.behaviors.sign_up!
    end
  end

  def signed_up_at
    self.behaviors.sign_ups.first.try(:created_at)
  end

  class << self
    def find_or_create open_id
      where(open_id: open_id).first.tap do |user|
        user.try(:behaviors).try(:sign_in!)
      end || create!(open_id: open_id).tap do |user|
        user.behaviors.touch!
      end
    end

    def faker
      create!(open_id: "faker_#{SecureRandom.urlsafe_base64}").tap do |user|
        user.behaviors.touch!
      end
    end

    def phone_exist? phone
      where(phone: phone).first
    end

    def nickname_exist? nickname
      where(nickname: nickname).first
    end
  end
end