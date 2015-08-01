class Behavior < ActiveRecord::Base
  belongs_to :user
  as_enum :content, [:touch, :sign_up, :sign_in, :subscribe, :unsubscribe], map: :string

  self.contents.keys.each do |content|
    define_singleton_method "#{content}!" do
      create!(content: content)
    end
  end
end