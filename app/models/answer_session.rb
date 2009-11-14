# An AnswerSession is a virtual (ie. not ActiveRecord) object that represents
# a session in which a particular responder is answering questions.  AnswerSession
# objects must have a valid Responder.
class AnswerSession
  attr_reader :responder

  def initialize(options={})
    raise ArgumentError.new("no responder specified") if options[:responder].nil?
    raise ArgumentError.new("specified responder is wrong type") unless options[:responder].is_a?(Responder)
    @responder = options[:responder]
  end

  # Return a list of answers from this session's responder
  def answers
    Answer.find(:all, :conditions => {:responder_id => responder.id})
  end

  # Return the next unanswered question for this session's responder
  def next_question
    if answers.empty?
      Question.find(:first)
    else
      Question.find(:first, :conditions => ['id NOT IN (?)', answers.collect{|a| a.question_id}])
    end
  end
end