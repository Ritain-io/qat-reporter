ParameterType(
  regexp: /""/,
  transformer: ->  do
   nil
  end
)


ParameterType(

  regexp: /^\d+$/,
  transformer: -> (regexp) do
    regexp.to_i
  end
)

ParameterType(

  regexp: /^[A-Z:]+::VERSION$/,
  transformer: -> (regexp) do
    eval regexp
  end
)

