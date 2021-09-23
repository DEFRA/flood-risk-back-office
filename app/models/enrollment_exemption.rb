# An EnrollmentExemption is equivalent to a 'registration'.
# When a back office user actions a registration, they have
# to add comments. Here we add an `#action!` method, to enable
# validation and creation of new comments
class EnrollmentExemption < FloodRiskEngine::EnrollmentExemption
  attr_accessor :commentable, :comment_content, :comment_event

  validates :comment_content, presence: true, length: { maximum: 500 }, if: :commentable?
  before_save :create_comment, if: :commentable?

  delegate :reference_number, to: :enrollment

  def action!(params)
    @commentable = true
    update(params)
  end

  class << self
    def status_keys
      FloodRiskEngine::EnrollmentExemption.statuses.except(:building).keys
    end
  end

  private

  def commentable?
    @commentable
  end

  def create_comment
    comments.create(content: comment_content, event: comment_event)
  end
end
