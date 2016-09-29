class Locale < ActiveRecord::Base
  include Resolvable

  default_scope { order(:code) }

  belongs_to :project

  has_many :translations
  has_many :releases
  has_many :highlights

  scope :alphabetical,  -> { order :code }

  validates :code, uniqueness: { scope: :project_id },
                   length: { minimum: 1 },
                   format: { with: /\A[a-zA-Z0-9_]+\z/ }

  scope :alphabetical, -> { order :code }

  def to_s
    code
  end
end
