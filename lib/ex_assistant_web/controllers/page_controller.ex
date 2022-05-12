defmodule ExAssistantWeb.PageController do
  use ExAssistantWeb, :controller

    @get """
    netRemote.play.info.album
    netRemote.play.info.artist
    netRemote.play.info.duration
    netRemote.play.info.graphicUri
    netRemote.play.info.name
    netRemote.play.info.text
    netRemote.play.status
    netRemote.sys.audio.mute
    netRemote.sys.audio.volume
    netRemote.sys.caps.volumeSteps
    netRemote.sys.info.friendlyName
    netRemote.sys.info.version
    netRemote.sys.isu.control
    netRemote.sys.isu.state
    netRemote.sys.mode
    netRemote.sys.net.ipConfig.address
    netRemote.sys.net.ipConfig.dhcp
    netRemote.sys.net.ipConfig.dnsPrimary
    netRemote.sys.net.ipConfig.dnsSecondary
    netRemote.sys.net.ipConfig.gateway
    netRemote.sys.net.ipConfig.subnetMask
    netRemote.sys.net.keepConnected
    netRemote.sys.net.wired.interfaceEnable
    netRemote.sys.net.wlan.connectedSSID
    netRemote.sys.net.wlan.interfaceEnable
    netRemote.sys.net.wlan.region
    netRemote.sys.net.wlan.regionFcc
    netRemote.sys.net.wlan.rssi
    netRemote.sys.net.wlan.scan
    netRemote.sys.net.wlan.setAuthType
    netRemote.sys.net.wlan.setEncType
    netRemote.sys.power
    """
    @list """
    netRemote.sys.caps.validModes
    netRemote.sys.net.wlan.scan
    """
    @set """
    netRemote.play.control
    netRemote.sys.audio.mute
    netRemote.sys.audio.volume
    netRemote.sys.info.friendlyName
    netRemote.sys.mode
    netRemote.sys.net.wired.interfaceEnable
    netRemote.sys.net.wlan.interfaceEnable
    netRemote.sys.net.wlan.keepConnected
    netRemote.sys.net.wlan.scan
    netRemote.sys.power
    """
  def index(conn, _params) do
    connection = FrontierSilicon.Worker.connect 
    params =
    @get <> @list
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {param, index} -> {index, param, get_param(connection, param)} end)

    render(conn, "index.html", params: params)
  end
  defp get_param(connection, param) do
        try do
      FrontierSilicon.Worker.handle_get(connection, param)
      rescue
        error -> IO.inspect(error); :error
      end
  end
end
