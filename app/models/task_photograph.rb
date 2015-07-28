class TaskPhotograph < ActiveRecord::Base
  belongs_to :task
  before_create :set_position
  mount_uploader :file, TaskPhotographFileUploader

  protected
    def set_position
      self.position ||= (self.class.where(task_id: self.task_id).maximum(:position) || 0) + 1
    end
end
