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
end