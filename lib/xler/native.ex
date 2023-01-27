defmodule Xler.Native do
  @moduledoc false

  version = Mix.Project.config()[:version]

  force_build =
    Application.compile_env(
      :xler,
      :force_build,
      System.get_env("RUSTLER_PRECOMPILATION_BUILD") in ["1", "true"]
    )

  use RustlerPrecompiled,
    otp_app: :xler,
    crate: "xler_native",
    base_url: "https://github.com/Finbits/xler/releases/download/v#{version}",
    force_build: force_build,
    version: version

  def parse(_filename, _worksheet), do: error()
  def worksheets(_filename), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
