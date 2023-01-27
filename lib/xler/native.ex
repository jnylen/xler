defmodule Xler.Native do
  @moduledoc false

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :xler,
    crate: "xler_native",
    base_url: "https://github.com/Finbits/xler/releases/download/v#{version}",
    # TODO: fetch from application config
    force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
    version: version

  def parse(_filename, _worksheet), do: error()
  def worksheets(_filename), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
