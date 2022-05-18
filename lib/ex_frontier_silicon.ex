defmodule ExFrontierSilicon do
  alias ExFrontierSilicon.Constants
  alias ExFrontierSilicon.Connector

  defdelegate connect, to: Connector
  defdelegate disconnect(conn), to: Connector

  def get_play_current(conn) do
    Connector.handle_get_multiple(conn, Constants.play_current())
  end

  def get_play_info(conn) do
    Connector.handle_get_multiple(conn, Constants.play_info())
  end

  def get_audio(conn) do
    Connector.handle_get_multiple(conn, Constants.audio())
  end

  def get_info(conn) do
    Connector.handle_get_multiple(conn, Constants.info())
  end

  def get_nav(conn) do
    Connector.handle_get_multiple(conn, Constants.nav())
  end

  def get_wired(conn) do
    Connector.handle_get_multiple(conn, Constants.wired())
  end

  def get_ipconfig(conn) do
    Connector.handle_get_multiple(conn, Constants.ipconfig())
  end

  def get_clock(conn) do
    Connector.handle_get_multiple(conn, Constants.clock())
  end

  def get_wlan(conn) do
    Connector.handle_get_multiple(conn, Constants.wlan())
  end

  def get_play_info_name(conn) do
    Connector.handle_get(conn, "netRemote.play.info.name")
  end

  def get_play_info_text(conn) do
    Connector.handle_get(conn, "netRemote.play.info.text")
  end

  def get_play_info_artist(conn) do
    Connector.handle_get(conn, "netRemote.play.info.artist")
  end

  def get_play_info_album(conn) do
    Connector.handle_get(conn, "netRemote.play.info.album")
  end

  def get_play_info_graphics(conn) do
    Connector.handle_get(conn, "netRemote.play.info.graphicUri")
  end

  def get_volume_steps(conn) do
    Connector.handle_get(conn, "netRemote.sys.caps.volumeSteps")
  end

  def get_play_status(conn) do
    status = Connector.handle_get(conn, "netRemote.play.status")
    Constants.net_remote_play_states(status)
  end

  def get_volume(conn) do
    Connector.handle_get(conn, "netRemote.sys.audio.volume")
  end

  def get_mute(conn) do
    Connector.handle_get(conn, "netRemote.sys.audio.mute")
  end

  def get_power(conn) do
    Connector.handle_get(conn, "netRemote.sys.power")
  end

  def get_friendly_name(conn) do
    Connector.handle_get(conn, "netRemote.sys.info.friendlyName")
  end

  def get_duration(conn) do
    with duration when is_integer(duration) <-
           Connector.handle_get(conn, "netRemote.play.info.duration") do
      Time.add(~T[00:00:00], duration, :millisecond)
    end
  end

  def get_mode(conn) do
    mode = Connector.handle_get(conn, "netRemote.sys.mode")
    Enum.find(get_modes(conn), fn %{"key" => key} -> key == mode end)
  end

  def get_eq_modes(conn) do
    Connector.handle_list(conn, "netRemote.sys.caps.eqPresets")
  end

  def get_wifi_scan(conn) do
    Connector.handle_list(conn, "netRemote.sys.net.wlan.scanList")
  end

  def get_modes(conn) do
    Connector.handle_list(conn, "netRemote.sys.caps.validModes")
  end

  def init_radio(conn) do
    play_control(conn, :init)
  end

  def play(conn) do
    play_control(conn, :play)
  end

  def pause(conn) do
    play_control(conn, :pause)
  end

  def forward(conn) do
    play_control(conn, :forward)
  end

  def rewind(conn) do
    play_control(conn, :rewind)
  end

  def play_control(conn, value) do
    Connector.handle_set(conn, "netRemote.play.control", Constants.play_control(value))
  end

  def set_volume(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.audio.volume", value)
  end

  def set_friendly_name(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.info.friendlyName", value)
  end

  def set_mute(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.audio.mute", value)
  end

  def set_power(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.power", value)
  end

  def set_mode(conn, mode) do
    Connector.handle_set(conn, "netRemote.sys.mode", mode)
  end

  def nav_reset(conn) do
    nav(conn, -1)
  end

  def nav(conn, value) do
    Connector.handle_set(conn, "netRemote.nav.action.navigate", value)
  end

  def nav_into_sub(conn, value) do
    nav(conn, "0xffffffff")
  end

  def nav_select(conn) do
    Connector.handle_set(conn, "netRemote.nav.action.selectItem", value)
  end

  def search(conn, value) do
    Connector.handle_set(conn, "netRemote.nav.searchTerm", value)
  end

  def nav_num_items(conn) do
    Connector.handle_get(conn, "netRemote.nav.numItems")
  end

  def nav_menu(conn) do
    ExFrontierSilicon.Connector.handle_list(conn, "netRemote.nav.list")
  end

  def get_status(conn) do
    Connector.handle_get(conn, "netRemote.nav.status")
  end

  def nav_state(conn) do
    Connector.handle_get(conn, "netRemote.nav.state")
  end

  def nav_disable(conn) do
    Connector.handle_set(conn, "netRemote.nav.state", 0)
  end

  def nav_enable(conn) do
    Connector.handle_set(conn, "netRemote.nav.state", 1)
  end

  def get_notifies(conn) do
    Connector.handle_get_notifies(conn)
  end
end
