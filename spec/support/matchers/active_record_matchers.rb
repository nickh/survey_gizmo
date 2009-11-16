def check_reflection(object, reflection, macro)
  klass = object.is_a?(Class) ? object : object.class
  klass.reflections.has_key?(reflection) && klass.reflections[reflection].macro == macro
end

Spec::Matchers.define :belong_to do |expected|
  match                          {|actual| check_reflection(actual, expected, :belongs_to)}
  failure_message_for_should     {|actual| "expected #{actual.inspect} to belong_to #{expected.inspect}"}
  failure_message_for_should_not {|actual| "expected #{actual.inspect} to not belong_to #{expected.inspect}"}
end

Spec::Matchers.define :have_one do |expected|
  match                          {|actual| check_reflection(actual, expected, :has_one)}
  failure_message_for_should     {|actual| "expected #{actual.inspect} to have_one #{expected.inspect}"}
  failure_message_for_should_not {|actual| "expected #{actual.inspect} to not have_one #{expected.inspect}"}
end

Spec::Matchers.define :have_many do |expected|
  match                          {|actual| check_reflection(actual, expected, :has_many)}
  failure_message_for_should     {|actual| "expected #{actual.inspect} to have_many #{expected.inspect}"}
  failure_message_for_should_not {|actual| "expected #{actual.inspect} to not have_many #{expected.inspect}"}
end

Spec::Matchers.define :have_errors_on do |expected|
  match                          {|actual| !actual.errors_on(:expected).nil?}
  failure_message_for_should     {|actual| "expected #{actual.inspect} to have errors on #{expected.inspect}"}
  failure_message_for_should_not {|actual| "expected #{actual.inspect} to not have errors on #{expected.inspect}"}
end