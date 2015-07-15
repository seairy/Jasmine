class User < ActiveRecord::Base
  include UUID, AASM
  has_many :behaviors
  aasm column: 'state' do
    state :unactivated, initial: true
    state :activated
    state :prohibited
    event :active do
      transitions from: :unactivated, to: :activated
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
  end
end