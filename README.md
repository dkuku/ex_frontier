# ExFrontier
## Documentation
[documentation on hexdocs](https://hexdocs.pm/ex_frontier)
## Usage examples
    c = ExFrontier.connect()
    ExFrontier.power(c, 1)
    ExFrontier.play(c)
    ExFrontier.get_play_info(c)

## Config is needed
    config :ex_frontier,
    hostname: "192.168.1.151",
    max_get_multiple_count: 10,
    path: "device",
    pin: 1234,
    port: "80"

## Sniffing data
how I got the data:

    create an ap
    sudo create_ap wlp0s20f0u1 wlp58s0 kuku 
    sudo bettercap -no-colors -eval "events.stream off; set events.stream.output ~/bettercap-events.log; events.stream on" -iface wlp0s20f0u1 

## Learn more
https://hexdocs.pm/sweet_xml/readme.html

https://github.com/elixir-tesla/tesla

https://www.w3schools.com/xml/xpath_syntax.asp

https://github.com/flammy/fsapi/blob/master/FSAPI.md

https://github.com/dkuku/node-frontier-silicon
