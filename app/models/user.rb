class User < ActiveRecord::Base
  has_paper_trail

  has_many :commitments, inverse_of: :user
  has_many :identities, inverse_of: :user

  validates :first_name, :last_name, presence: true
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }

  strip_attributes collapse_spaces: true

  def short_name
    first_name || email
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  alias_method :to_s, :name
end
