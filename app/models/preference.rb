class Preference < ActiveRecord::Base
  class << self
    def commission_rate
      self.where(name: 'commission_rate').first.value.to_f
    end

    def deposit_ratio
      self.where(name: 'deposit_ratio').first.value.to_f
    end
  end
end
