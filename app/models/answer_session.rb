# An AnswerSession is a virtual (ie. not ActiveRecord) object that represents
# a session in which a particular responder is answering questions.  AnswerSession
# objects must have a valid Responder.
class AnswerSession
  attr_reader :responder

  def initialize(options={})
  end

  # Return a list of answers from this session's responder
  def answers
    []
  end

  # Return the next unanswered question for this session's responder
  def next_question
  end
end