exceptions = %w(
  PermissionDenied
  FrequentRequest
  TooManyRequest
  InvalidState
  DuplicatedPhone
  DuplicatedNickname
  InvalidPhone
  InvalidVerificationCode
  IncorrectVerificationCode
  InvalidNickname
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 