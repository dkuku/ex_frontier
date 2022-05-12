# ExAssistant

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more
https://hexdocs.pm/sweet_xml/readme.html
https://github.com/elixir-tesla/tesla
https://www.w3schools.com/xml/xpath_syntax.asp
https://github.com/flammy/fsapi/blob/master/FSAPI.md
https://github.com/dkuku/node-frontier-silicon

iex(18)> dur = FrontierSilicon.Worker.connect |> FrontierSilicon.Worker.handle_get("netRemote.sys.net.ipConfig.address") |> xpath(~x"/fsapiResponse/value/*") |> elem(1)
