defmodule F1Bot.MixProject do
  use Mix.Project

  def project do
    [
      app: :f1_bot,
      version: "0.7.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: "https://github.com/recursiveGecko/race_bot",
      homepage_url: "https://github.com/recursiveGecko/race_bot",
      compilers: Mix.compilers() ++ [:surface],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:nostrum, :mix],
        list_unused_filters: true
      ],
      releases: [
        f1bot: [
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent,
            nostrum: :load
          ],
          strip_beams: false
        ]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tools] ++ extra_applications(Mix.env()),
      included_applications: [],
      mod: {F1Bot.Application, []}
    ]
  end

  defp extra_applications(:dev), do: [:observer, :wx]
  defp extra_applications(_env), do: []

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "LICENSE.md"
      ],
      groups_for_modules: [
        "Live Timing API": ~r/^F1Bot.ExternalApi.SignalR/,
        "F1 Session (boundary)": ~r/^F1Bot.F1Session.Server/,
        "F1 Session (functional)": ~r/^F1Bot.F1Session/,
        "Output servers": ~r/^F1Bot.Output/,
        Plotting: ~r/^F1Bot.Plotting/,
        "Other external APIs": ~r/^F1Bot.ExternalApi/
      ],
      groups_for_functions: [],
      source_ref: "master",
      nest_modules_by_prefix: [
        F1Bot.F1Session,
        F1Bot.Output,
        F1Bot.Plotting,
        F1Bot.ExternalApi.Discord,
        F1Bot.ExternalApi.SignalR
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "esbuild.install --if-missing",
        "cmd --cd assets npm install --ignore-scripts"
      ],
      "assets.build": ["hooks.build", "tailwind default", "esbuild default"],
      "assets.deploy": [
        "hooks.build",
        "tailwind default --minify",
        "esbuild default --minify",
        "phx.digest"
      ],
      # Builds Surface UI hooks -> ./assets/js/_hooks
      "hooks.build": ["compile"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {
        :nostrum,
        # Includes https://github.com/Kraigie/nostrum/pull/522
        git: "https://github.com/Kraigie/nostrum",
        ref: "4fabfc5bf59878fdde118acd686f6a5e075b5f8e",
        runtime: false
      },
      # {:flame_on, "~> 0.5.2", only: :dev},
      {:certifi, "~> 2.13.0"},
      {:contex, "~> 0.5.0"},
      {:credo, "~> 1.7.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.0", only: [:dev], runtime: false},
      {:ecto_sql, "~> 3.11.0"},
      {:ecto_sqlite3, "~> 0.16.0"},
      {:eflame, "~> 1.0"},
      {:esbuild, "~> 0.8.0", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.34.0", runtime: false},
      {:finch, "~> 0.18.0"},
      {:floki, ">= 0.36.0", only: :test},
      {:fresh, "~> 0.4.4"},
      {:gnuplot, "~> 1.22"},
      {:heroicons, "~> 0.5.2"},
      {:jason, "~> 1.4"},
      {:kino, "~> 0.13.0", only: :dev},
      {:mogrify, "~> 0.9.2"},
      {:nimble_parsec, "~> 1.4.0"},
      {:phoenix, "~> 1.7.0"},
      {:phoenix_ecto, "~> 4.6.0"},
      {:phoenix_html, "~> 3.3.0"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:phoenix_live_reload, "~> 1.5.0", only: :dev},
      {:phoenix_live_view, "~> 0.20.0"},
      {:phoenix_pubsub, "~> 2.1"},
      {:plug_cowboy, "~> 2.6"},
      {:rexbug, ">= 2.0.0-rc1"},
      {:scribe, "~> 0.10.0", only: :dev},
      {:surface, "~> 0.11.0"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0.0"},
      {:telemetry_poller, "~> 1.1.0"},
      {:timex, "~> 3.7.0"},
      {:typed_struct, "~> 0.3.0"},
      {:vega_lite, "~> 0.1.6", only: :dev}
    ]
  end
end
