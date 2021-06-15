# Always warning as errors
if Version.match?(System.version(), "~> 1.10") do
  Code.put_compiler_option(:warnings_as_errors, true)
end

# Define dynamic mocks
Mox.defmock(SGP40.MockTransport, for: SGP40.Transport)

# Override the config settings
Application.put_env(:sgp40, :transport_module, SGP40.MockTransport)

ExUnit.start()
