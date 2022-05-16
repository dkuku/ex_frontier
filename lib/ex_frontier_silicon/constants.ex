defmodule ExFrontierSilicon.Constants do
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

  @nav [
    "netRemote.nav.caps",
    "netRemote.nav.description",
    "netRemote.nav.numItems",
    "netRemote.nav.preset.currentPreset",
    "netRemote.nav.status"
  ]
  @play_info [
    "netRemote.play.info.album",
    "netRemote.play.info.artist",
    "netRemote.play.info.description",
    "netRemote.play.info.duration",
    "netRemote.play.info.graphicUri",
    "netRemote.play.info.name",
    "netRemote.play.info.text"
  ]
  @play_current [
    "netRemote.play.caps",
    "netRemote.play.position",
    "netRemote.play.status"
  ]
  @audio [
    "netRemote.sys.audio.airableQuality",
    "netRemote.sys.audio.eqCustom.param0",
    "netRemote.sys.audio.eqCustom.param1",
    "netRemote.sys.audio.eqLoudness",
    "netRemote.sys.audio.eqPreset",
    "netRemote.sys.audio.extStaticDelay",
    "netRemote.sys.audio.mute",
    "netRemote.sys.audio.volume",
    "netRemote.sys.caps.volumeSteps"
  ]
  @clock [
    "netRemote.sys.clock.dst",
    "netRemote.sys.clock.localDate",
    "netRemote.sys.clock.localTime",
    "netRemote.sys.clock.mode",
    "netRemote.sys.clock.source",
    "netRemote.sys.clock.utcOffset"
  ]
  @info [
    "netRemote.sys.info.friendlyName",
    "netRemote.sys.info.radioId",
    "netRemote.sys.info.radiopin",
    "netRemote.sys.info.version",
    "netRemote.sys.isu.control",
    "netRemote.sys.isu.state",
    "netRemote.sys.lang",
    "netRemote.sys.mode",
    "netRemote.sys.power",
    "netRemote.sys.sleep"
  ]
  @ipconfig [
    "netRemote.sys.net.ipConfig.address",
    "netRemote.sys.net.ipConfig.dhcp",
    "netRemote.sys.net.ipConfig.dnsPrimary",
    "netRemote.sys.net.ipConfig.dnsSecondary",
    "netRemote.sys.net.ipConfig.gateway",
    "netRemote.sys.net.ipConfig.subnetMask"
  ]
  @wired [
    "netRemote.sys.net.keepConnected",
    "netRemote.sys.net.wired.interfaceEnable",
    "netRemote.sys.net.wired.macAddress"
  ]
  @wlan [
    "netRemote.sys.net.wlan.connectedSSID",
    "netRemote.sys.net.wlan.interfaceEnable",
    "netRemote.sys.net.wlan.macAddress",
    "netRemote.sys.net.wlan.region",
    "netRemote.sys.net.wlan.regionFcc",
    "netRemote.sys.net.wlan.rssi",
    "netRemote.sys.net.wlan.scan",
    "netRemote.sys.net.wlan.setAuthType",
    "netRemote.sys.net.wlan.setEncType",
    "netRemote.sys.net.wlan.setSSID"
  ]
  @list [
    "netRemote.multiroom.device.listAll",
    "netRemote.nav.form.item",
    "netRemote.nav.list",
    "netRemote.nav.presets",
    "netRemote.sys.caps.clockSourceList",
    "netRemote.sys.caps.eqBands",
    "netRemote.sys.caps.eqPresets",
    "netRemote.sys.caps.validLang",
    "netRemote.sys.caps.validModes",
    "netRemote.sys.net.wlan.scanList"
  ]
  @set [
    "netRemote.nav.action.navigate",
    "netRemote.nav.action.selectItem",
    "netRemote.nav.encformData",
    "netRemote.nav.preset.delete",
    "netRemote.nav.state",
    "netRemote.play.addPreset",
    "netRemote.play.control",
    "netRemote.play.repeat",
    "netRemote.play.shuffle",
    "netRemote.sys.audio.airableQuality",
    "netRemote.sys.audio.eqPreset",
    "netRemote.sys.audio.mute",
    "netRemote.sys.audio.volume",
    "netRemote.sys.cfg.irAutoPlayFlag",
    "netRemote.sys.factoryReset",
    "netRemote.sys.info.controllerName",
    "netRemote.sys.info.friendlyName",
    "netRemote.sys.isu.control",
    "netRemote.sys.lang",
    "netRemote.sys.mode",
    "netRemote.sys.net.ipConfig.dhcp",
    "netRemote.sys.net.keepConnected",
    "netRemote.sys.net.wired.interfaceEnable",
    "netRemote.sys.net.wlan.interfaceEnable",
    "netRemote.sys.net.wlan.keepConnected",
    "netRemote.sys.net.wlan.region",
    "netRemote.sys.net.wlan.scan",
    "netRemote.sys.net.wlan.setSSID",
    "netRemote.sys.power",
    "netRemote.sys.sleep"
  ]
  @get @play_current ++ @play_info ++ @audio ++ @info ++ @nav ++ @wired ++ @ipconfig ++ @clock ++ @wlan

  def get(), do: @get
  def set(), do: @set
  def list(), do: @list

  def play_current, do: @play_current
  def play_info, do: @play_info
  def audio, do: @audio
  def info, do: @info
  def nav, do: @nav
  def wired, do: @wired
  def ipconfig, do: @ipconfig
  def clock, do: @clock
  def wlan, do: @wlan

  def net_remote_play_states(key), do: @net_remote_play_states[key]

  def net_remote_clock_source(key), do: @net_remote_clock_source[key]

  def net_remote_time_mode(key), do: @net_remote_time_mode[key]

  def net_remote_wifi_scan(key), do: @net_remote_wifi_scan[key]

  def net_remote_auth(key), do: @net_remote_auth[key]

  def net_remots_encr(key), do: @net_remots_encr[key]

  def net_remote_isu_state(key), do: @net_remote_isu_state[key]

  def net_remote_isu_control(key), do: @net_remote_isu_control[key]

  def net_remote_rsa_status(key), do: @net_remote_rsa_status[key]
end
