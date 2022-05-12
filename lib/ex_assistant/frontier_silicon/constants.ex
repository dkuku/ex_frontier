defmodule FrontierSilicon.Constants do
  import SweetXml
  @net_remote_play_states %{
    0 => :stopped,
    1 => :unknown,
    2 => :playing,
    3 => :paused
  }
  @net_remote_clock_source %{
    0 => :none,
    1 => :dab,
    2 => :fm,
    4 => :network,
    15 => :any
  }
  @net_remote_time_mode %{
    0 => :hr12,
    1 => :hr24
  }
  @net_remote_wifi_scan %{
    0 => :idle,
    1 => :scan
  }
  @net_remote_auth %{
    0 => :open,
    1 => :psk,
    2 => :wpa,
    3 => :wpa2
  }

  @net_remots_encr %{
    0 => :none,
    1 => :wep,
    2 => :tkip,
    3 => :aes
  }

  @net_remote_isu_state %{
    0 => :idle,
    1 => :checking,
    2 => :available,
    3 => :not_available,
    4 => :fail
  }

  @net_remote_isu_control %{
    0 => :idle,
    1 => :update,
    2 => :check
  }

  @net_remote_rsa_status %{
    0 => :generating,
    1 => :ready
  }

  @get """
  netRemote.avs.hastoken
  netRemote.nav.caps
  netRemote.nav.description
  netRemote.nav.numItems
  netRemote.nav.preset.currentPreset
  netRemote.nav.status
  netRemote.play.addPresetStatus
  netRemote.play.caps
  netRemote.play.errorStr
  netRemote.play.info.album
  netRemote.play.info.artist
  netRemote.play.info.description
  netRemote.play.info.duration
  netRemote.play.info.graphicUri
  netRemote.play.info.name
  netRemote.play.info.text
  netRemote.play.position
  netRemote.play.status
  netRemote.sys.audio.airableQuality
  netRemote.sys.audio.eqCustom.param0
  netRemote.sys.audio.eqCustom.param1
  netRemote.sys.audio.eqLoudness
  netRemote.sys.audio.eqPreset
  netRemote.sys.audio.extStaticDelay
  netRemote.sys.audio.mute
  netRemote.sys.audio.volume
  netRemote.sys.caps.volumeSteps
  netRemote.sys.clock.dst
  netRemote.sys.clock.localDate
  netRemote.sys.clock.localTime
  netRemote.sys.clock.mode
  netRemote.sys.clock.source
  netRemote.sys.clock.utcOffset
  netRemote.sys.info.friendlyName
  netRemote.sys.info.radioId
  netRemote.sys.info.radiopin
  netRemote.sys.info.version
  netRemote.sys.isu.control
  netRemote.sys.isu.state
  netRemote.sys.lang
  netRemote.sys.mode
  netRemote.sys.net.ipConfig.address
  netRemote.sys.net.ipConfig.dhcp
  netRemote.sys.net.ipConfig.dnsPrimary
  netRemote.sys.net.ipConfig.dnsSecondary
  netRemote.sys.net.ipConfig.gateway
  netRemote.sys.net.ipConfig.subnetMask
  netRemote.sys.net.keepConnected
  netRemote.sys.net.wired.interfaceEnable
  netRemote.sys.net.wired.macAddress
  netRemote.sys.net.wlan.connectedSSID
  netRemote.sys.net.wlan.interfaceEnable
  netRemote.sys.net.wlan.macAddress
  netRemote.sys.net.wlan.region
  netRemote.sys.net.wlan.regionFcc
  netRemote.sys.net.wlan.regionfcc
  netRemote.sys.net.wlan.rssi
  netRemote.sys.net.wlan.scan
  netRemote.sys.net.wlan.setAuthType
  netRemote.sys.net.wlan.setEncType
  netRemote.sys.net.wlan.setSSID
  netRemote.sys.power
  netRemote.sys.rsa.publicKey
  netRemote.sys.rsa.status
  netRemote.sys.sleep
  netRemote.sys.wlan.regionfcc
  """
  @list """
  netRemote.multiroom.device.listAll
  netRemote.nav.form.item
  netRemote.nav.list
  netRemote.nav.presets
  netRemote.sys.caps.clockSourceList
  netRemote.sys.caps.eqBands
  netRemote.sys.caps.eqPresets
  netRemote.sys.caps.validLang
  netRemote.sys.caps.validModes
  netRemote.sys.net.wlan.scanList
  """
  @set """
  netRemote.nav.action.navigate
  netRemote.nav.action.selectItem
  netRemote.nav.encformData
  netRemote.nav.preset.delete
  netRemote.nav.state
  netRemote.play.addPreset
  netRemote.play.control
  netRemote.play.repeat
  netRemote.play.shuffle
  netRemote.sys.audio.airableQuality
  netRemote.sys.audio.eqPreset
  netRemote.sys.audio.mute
  netRemote.sys.audio.volume
  netRemote.sys.cfg.irAutoPlayFlag
  netRemote.sys.factoryReset
  netRemote.sys.info.controllerName
  netRemote.sys.info.friendlyName
  netRemote.sys.isu.control
  netRemote.sys.lang
  netRemote.sys.mode
  netRemote.sys.net.ipConfig.dhcp
  netRemote.sys.net.keepConnected
  netRemote.sys.net.wired.interfaceEnable
  netRemote.sys.net.wlan.interfaceEnable
  netRemote.sys.net.wlan.keepConnected
  netRemote.sys.net.wlan.region
  netRemote.sys.net.wlan.scan
  netRemote.sys.net.wlan.setSSID
  netRemote.sys.power
  netRemote.sys.sleep
  """
  def get(), do: @get
  def set(), do: @set
  def list(), do: @list
  
  def postprocess_response(value, :array, _item), do: Base.decode16!(String.upcase(value))
  def postprocess_response(value, _, "netRemote.sys.net.ipConfig." <> item) when item != "dhcp",
    do: int_to_ip(value)

  def postprocess_response(value, _, _), do: value

  def parse_response(response, type) do
    xpath =
      case type do
        :u8 -> ~x"/fsapiResponse/value/u8/text()"i
        :u16 -> ~x"/fsapiResponse/value/u16/text()"i
        :u32 -> ~x"/fsapiResponse/value/u32/text()"i
        :s8 -> ~x"/fsapiResponse/value/s8/text()"i
        :s16 -> ~x"/fsapiResponse/value/s16/text()"i
        :s32 -> ~x"/fsapiResponse/value/s32/text()"i
        :c8_array -> ~x"/fsapiResponse/value/c8_array/text()"s
        :array -> ~x"/fsapiResponse/value/array/text()"s
        _ -> IO.inspect(response, label: :unsupported_response)
      end

    xpath(response, xpath)
  end
  def get_response_status(response) do
    
    case xpath(response, ~x"/fsapiResponse/status/text()"s) do
      "FS_OK" -> :ok
      "FS_FAIL" -> {:error, :fail}
      "FS_PACKET_BAD" -> {:error, :bad_packet}
      "FS_NODE_DOES_NOT_EXIST" -> {:error, :not_exist}
      "FS_NODE_BLOCKED" -> {:error, :blocked}
      "FS_TIMEOUT" -> {:error, :timeout}
      "FS_LIST_END" -> {:error, :list_end}
    end
  end

  def get_response_type(response) do
    response
    |> xpath(~x"/fsapiResponse/value/*")
    |> elem(1)
  end

  def int_to_ip(ip_int) do
    [
      div(ip_int, 16_777_216),
      rem(div(ip_int, 65536), 256),
      rem(div(ip_int, 256), 256),
      rem(ip_int, 256)
    ]
    |> Enum.join(".")
  end
end
