Spec::Matchers.define :belong_to do |expected|
  assoc_class = expected.to_s.camelize.constantize
  assoc_builder = "build_#{expected}".to_sym

  match do |actual|
    actual.respond_to?(expected) && actual.send(assoc_builder).is_a?(assoc_class)
  end

  failure_message_for_should do |actual|
    "expected #{actual.inspect} to belong_to #{expected.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual.inspect} to not belong_to #{expected.inspect}"
  end
end