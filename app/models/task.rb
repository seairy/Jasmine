class Task < ActiveRecord::Base
  include UUID, AASM
  belongs_to :demander, class_name: 'User'
  belongs_to :supplier, class_name: 'User'
  belongs_to :category
  belongs_to :region
  has_many :photographs, class_name: 'TaskPhotograph'
  has_many :operations, class_name: 'TaskOperation'
  before_create :set_default_values
  as_enum :reason_of_cancellation, [:out_of_stock, :reroute, :subjective_issue], prefix: true, map: :string
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
    event :purchase do
      transitions from: :shopping, to: :clearing
    end
    event :clear do
      transitions from: :clearing, to: :delivering
    end
    event :finish do
      transitions from: :delivering, to: :finished
    end
    event :cancel do
      transitions from: :shopping, to: :cancelled
    end
    event :trash do
      transitions from: [:pending, :publishing], to: :trashed
    end
  end
  validates :content, presence: true, length: { in: 10..2000 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99 }
  validates :estimate_unit_price, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100000 }
  validates :estimate_total_price, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 100000 }, if: 'actual_total_price'
  validates :actual_unit_price, numericality: { less_than_or_equal_to: 100000 }, if: 'actual_unit_price'
  validates :actual_total_price, numericality: { less_than_or_equal_to: 100000 }, if: 'actual_total_price'
  validates :deposit, numericality: true, if: 'deposit'
  validates :balance, numericality: true, if: 'balance'
  validates :commission, numericality: true, if: 'commission'

  def pay_deposit!
    self.with_lock do
      self.deposit_paid = true
      self.update!(published_at: Time.now)
      self.publish!
    end
  end

  def pay_final!
    self.with_lock do
      self.final_paid = true
      self.update!(cleared_at: Time.now)
      self.clear!
    end
  end

  def accept_by user
    raise InvalidState.new unless self.publishing?
    raise InvalidSupplier.new if user.id == self.demander_id
    self.with_lock do
      self.update!(supplier: user, accepted_at: Time.now)
      self.accept!
    end
  end

  def trash_by user
    raise InvalidState.new unless (self.pending? or self.publishing?)
    raise InvalidDemander.new unless user.id == self.demander_id
    self.with_lock do
      self.update!(trashed_at: Time.now)
      self.trash!
    end
  end

  def cancel_by user, reason_of_cancellation
    raise InvalidState.new unless self.shopping?
    raise InvalidSupplier.new unless user.id == self.supplier_id
    self.with_lock do
      self.update!(reason_of_cancellation: reason_of_cancellation, cancelled_at: Time.now)
      self.cancel!
    end
  end

  def purchase_by user, actual_price
    raise InvalidState.new unless self.shopping?
    raise InvalidSupplier.new unless user.id == self.supplier_id
    self.with_lock do
      commission = actual_price * Preference.commission_rate
      balance = ((actual_price + commission) <= deposit ? 0 : (actual_price + commission - deposit))
      self.update!(balance: balance, commission: commission, purchased_at: Time.now)
      self.purchase!
    end
  end

  def clear_by user
    raise InvalidState.new unless self.clearing?
    raise InvalidDemander.new unless user.id == self.demander_id
    self.with_lock do
      self.final_paid = true
      self.update!(cleared_at: Time.now)
      self.clear!
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
          task.demander.consignees.create!(name: task_params[:consignee_name], phone: task_params[:consignee_phone], address: task_params[:consignee_address], postal_code: task_params[:consignee_postal_code]) if task.demander.consignees.where(name: task_params[:consignee_name], phone: task_params[:consignee_phone], address: task_params[:consignee_address], postal_code: task_params[:consignee_postal_code]).first.nil? and task.demander.consignees.count <= 5
        end
      end
    end
  end

  protected
    def set_default_values
      self.estimate_total_price = self.estimate_unit_price * self.quantity
      self.deposit = (self.estimate_total_price.to_f * Preference.deposit_ratio).round
      self.deposit_paid = false
      self.final_paid = false
      self.commission = (self.estimate_total_price.to_f * Preference.commission_rate).round
    end
end
