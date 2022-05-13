# ExAssistant

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## sniffing data

create an ap
    sudo create_ap wlp0s20f0u1 wlp58s0 kuku 
    sudo bettercap -no-colors -eval "events.stream off; set events.stream.output ~/bettercap-events.log; events.stream on" -iface wlp0s20f0u1 

## commands
/GET
/GET/netRemote.sys.sleep  
/GET_NOTIFIES?sid=156666519 
/GET_MULTIPLE?node=netRemote.avs.hastoken&node=netRemote.cast....
/GET_MULTIPLE?node=netRemote.sys.power&node=netRemote.sys.mode& 

/SET
## Learn more
https://hexdocs.pm/sweet_xml/readme.html

https://github.com/elixir-tesla/tesla

https://www.w3schools.com/xml/xpath_syntax.asp

https://github.com/flammy/fsapi/blob/master/FSAPI.md

https://github.com/dkuku/node-frontier-silicon
