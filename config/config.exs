import Config

if Mix.env() == :test do
  config :sgp40, transport_mod: SGP40.MockTransport
end
