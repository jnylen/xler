import Config

if Mix.env() == :test do
  config :xler, force_build: true
end
