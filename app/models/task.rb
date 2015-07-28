class Task < ActiveRecord::Base
  include UUID, AASM
  belongs_to :demander, class_name: 'User'
  belongs_to :supplier, class_name: 'User'
  belongs_to :region
  has_many :photographs, class_name: 'TaskPhotograph'
  before_create :set_default_values
  aasm column: 'state' do
    state :pending, initial: true
    state :publishing
    state :shopping
    state :clearing
    state :delivering
    state :finished
    state :cancelled
    state :trashed
    event :publish do
      transitions from: :pending, to: :publishing
    end
    event :accept do
      transitions from: :publishing, to: :shopping
    end
    event :buy do
      transitions from: :shopping, to: :clearing
    end
  end
  validates :content, presence: true, length: { in: 10..2000 }
  validates :estimate_price, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 100000 }
  validates :actual_price, numericality: { less_than_or_equal_to: 100000 }, if: 'actual_price'
  validates :deposit, numericality: true, if: 'deposit'
  validates :balance, numericality: true, if: 'balance'
  validates :commission, numericality: true, if: 'commission'

  def pay_deposit!
    ActiveRecord::Base.transaction do
      self.deposit_paid = true
      self.publish!
    end
  end

  class << self
    def create_with_photographs! task_params, photograph_params
      ActiveRecord::Base.transaction do
        task_params[:region_id] = nil if task_params[:region_id] == '0'
        create!(task_params).tap do |task|
          photograph_params.each do |photograph_param|
            task.photographs.create!(file: photograph_param)
          end if photograph_params
        end
      end
    end
  end

  protected
    def set_default_values
      self.deposit = (self.estimate_price.to_f * 0.7).round
      self.deposit_paid = false
      self.final_paid = false
      true
    end
end
