class Behavior < ActiveRecord::Base
  belongs_to :user
  as_enum :content, [:sign_up, :sign_in, :subscribe, :unsubscribe, :complete_information], map: :string

  self.contents.keys.each do |content|
    define_singleton_method "#{content}!" do
      create!(content: content)
    end
  end
end
