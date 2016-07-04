# Phoenix Template Engine for Markdown

> Powered by [Earmark](https://github.com/pragdave/earmark)


## Usage

  1. Add `{:phoenix_markdown, "~> 0.0.1"}` to your deps in `mix.exs`.
  2. Add the following to your Phoenix `config/config.exs`

     ```elixir
    config :phoenix, :template_engines,
      md: PhoenixMarkdown.Engine
     ```

    If you are also using the [phoenix_haml](https://github.com/chrismccord/phoenix_haml) engine, then it would look like this:
     ```elixir
    config :phoenix, :template_engines,
      haml: PhoenixHaml.Engine,
      md: PhoenixMarkdown.Engine
     ```


  3. Use the `.html.md` extensions for your templates.

## Optional

Add md extension to Phoenix live reload in `config/dev.exs`

```elixir
  config :hello_phoenix, HelloPhoenix.Endpoint,
    live_reload: [
      patterns: [
        ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
        ~r{web/views/.*(ex)$},
        ~r{web/templates/.*(eex|md)$}
      ]
    ]
```

If you are also using the [phoenix_haml](https://github.com/chrismccord/phoenix_haml) engine, then the pattern should look like this:

```elixir
  config :hello_phoenix, HelloPhoenix.Endpoint,
    live_reload: [
      patterns: [
        ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
        ~r{web/views/.*(ex)$},
        ~r{web/templates/.*(eex|haml|md)$}
      ]
    ]
```elixir