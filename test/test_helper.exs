# Always warning as errors
Code.put_compiler_option(:warnings_as_errors, true)

# Define dynamic mocks
Mox.defmock(SGP40.MockTransport, for: SGP40.Transport)

ExUnit.start()
