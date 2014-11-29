class User < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  strip_attributes collapse_spaces: true

  def to_s
    "#{first_name} #{last_name}"
  end
end