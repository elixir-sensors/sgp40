# Always warning as errors
if Version.match?(System.version(), "~> 1.10") do
  Code.put_compiler_option(:warnings_as_errors, true)
end

Application.put_env(:sgp40, :transport_module, SGP40.MockI2C)
Mox.defmock(SGP40.MockI2C, for: SGP40.Transport)

ExUnit.start()
