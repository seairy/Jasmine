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

  def complete_information options = {}
    ActiveRecord::Base.transaction do
      raise InvalidState.new unless self.unactivated?
      raise DuplicatedPhone.new if User.duplicated_phone?(options[:phone])
      raise DuplicatedNickname.new if User.duplicated_nickname?(options[:nickname])
      VerificationCode.validate_complete_information(user: self, phone: options[:phone], verification_code: options[:verification_code])
      update!(phone: options[:phone], nickname: options[:nickname])
      self.active!
      self.behaviors.complete_information!
    end
  end

  class << self
    def find_or_create open_id
      if user = where(open_id: open_id).first
        user.behaviors.sign_in!
      else
        user = create!(open_id: open_id)
        user.behaviors.sign_up!
      end
    end

    def faker
      create!(open_id: "faker_#{SecureRandom.urlsafe_base64}").tap do |user|
        user.behaviors.sign_up!
      end
    end

    def duplicated_phone? phone
      where(phone: phone).first
    end

    def duplicated_nickname? nickname
      where(nickname: nickname).first
    end
  end
end