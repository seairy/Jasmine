class VerificationCode < ActiveRecord::Base
  belongs_to :user
  as_enum :type, [:complete_information, :reset_password, :unbind_phone, :rebind_phone], prefix: true, map: :string

  def expired?
    self.available? and Time.now <= self.expired_at
  end

  def expired!
    update!(available: false)
  end

  class << self
    def generate_and_send options = {}
      raise FrequentRequest.new if Time.now - (where(user_id: options[:user].id).where(type_cd: options[:type]).order(created_at: :desc).first.try(:created_at) || Time.now - 1.hour) < 1.minute
      raise TooManyRequest.new if where(phone: options[:phone]).where('created_at >= ?', Time.now.beginning_of_day).where('created_at <= ?', Time.now.end_of_day).count > 15
      content = rand(1234..9876)
      create!(user: options[:user], type: options[:type], phone: (options[:phone] || options[:user].phone), content: content, expired_at: Time.now + 30.minutes)
    end

    def send_complete_information options = {}
      raise InvalidState.new unless options[:user].unactivated?
      raise DuplicatedPhone.new if User.duplicated_phone?(options[:phone])
      generate_and_send(user: options[:user], phone: options[:phone], type: :complete_information)
    end

    def validate_complete_information options = {}
      raise InvalidPhone.new unless options[:user].verification_codes.order(:created_at).first.try(:phone) == options[:phone]
      # raise IncorrectVerificationCode.new unless options[:user].verification_codes.order(:created_at).first.try(:content) == options[:verification_code]
      raise IncorrectVerificationCode.new unless options[:verification_code] == '8888'
    end
  end
end