class TaskOperation < ActiveRecord::Base
  include AASM
  belongs_to :task
  as_enum :content, [:create, :publish, :accept, :buy, :clear, :deliver, :confirm], map: :string
end