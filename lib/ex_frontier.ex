defmodule ExFrontier do
  @moduledoc """
  Library used for connecting and controlling radios based on [Frontier](https://www.frontiersmart.com/)

  from the manufacturer website
  Frontier’s leading SmartRadio modules combine DAB+, FM, Bluetooth with Internet Radio, Podcasts and audio streaming services including Spotify, Amazon Music, Tidal, Qobuz and Deezer. SmartRadios can be controlled with a Smartphone using the Frontier UNDOK™ application.

  Library is mostly based on sniffing traffic from the android app and also on some documentation found on the internet
  """
  alias ExFrontier.Connector
  alias ExFrontier.Constants

  @doc """
  creates a connection that needs to be passed to every request
  """
  defdelegate connect, to: Connector

  @doc """
  discards the session_id
  """
  defdelegate disconnect(conn), to: Connector

  @doc """
  returns a list of items about current track
  """
  def get_play_current(conn) do
    Connector.handle_get_multiple(conn, Constants.play_current())
  end

  @doc """
  returns a list of items about play state
  """
  def get_play_info(conn) do
    Connector.handle_get_multiple(conn, Constants.play_info())
  end

  @doc """
  returns a list of items about audio setup
  """
  def get_audio(conn) do
    Connector.handle_get_multiple(conn, Constants.audio())
  end

  @doc """
  returns system info
  """
  def get_info(conn) do
    Connector.handle_get_multiple(conn, Constants.info())
  end

  @doc """
  get a list of items about nav state
  """
  def get_nav(conn) do
    Connector.handle_get_multiple(conn, Constants.nav())
  end

  @doc """
  returns a list of items about wired connection
  """
  def get_wired(conn) do
    Connector.handle_get_multiple(conn, Constants.wired())
  end

  @doc """
  returns a list of items about current network settings
  """
  def get_ipconfig(conn) do
    Connector.handle_get_multiple(conn, Constants.ipconfig())
  end

  @doc """
  returns a list of items about clock
  """
  def get_clock(conn) do
    Connector.handle_get_multiple(conn, Constants.clock())
  end

  @doc """
  returns a list of items about wireless connection
  """
  def get_wlan(conn) do
    Connector.handle_get_multiple(conn, Constants.wlan())
  end

  @doc """
  returns name of current playing item
  """
  def get_play_info_name(conn) do
    Connector.handle_get(conn, "netRemote.play.info.name")
  end

  @doc """
  returns description of current playing item
  """
  def get_play_info_text(conn) do
    Connector.handle_get(conn, "netRemote.play.info.text")
  end

  @doc """
  returns current artist
  """
  def get_play_info_artist(conn) do
    Connector.handle_get(conn, "netRemote.play.info.artist")
  end

  @doc """
  returns current artist
  """
  def get_play_info_album(conn) do
    Connector.handle_get(conn, "netRemote.play.info.album")
  end

  @doc """
  returns cover uri
  """
  def get_play_info_graphics(conn) do
    Connector.handle_get(conn, "netRemote.play.info.graphicUri")
  end

  @doc """
  returns amount of volume steps
  """
  def get_volume_steps(conn) do
    Connector.handle_get(conn, "netRemote.sys.caps.volumeSteps")
  end

  @doc """
  returns playing status
  """
  def get_play_status(conn) do
    status = Connector.handle_get(conn, "netRemote.play.status")
    Constants.net_remote_play_states(status)
  end

  @doc """
  returns current volume
  """
  def get_volume(conn) do
    Connector.handle_get(conn, "netRemote.sys.audio.volume")
  end

  @doc """
  returns current mute state
  """
  def get_mute(conn) do
    Connector.handle_get(conn, "netRemote.sys.audio.mute")
  end

  @doc """
  returns current mute state
  """
  def get_power(conn) do
    Connector.handle_get(conn, "netRemote.sys.power")
  end

  @doc """
  returns friendly name of device
  """
  def get_friendly_name(conn) do
    Connector.handle_get(conn, "netRemote.sys.info.friendlyName")
  end

  @doc """
  returns track duration
  """
  def get_duration(conn) do
    with duration when is_integer(duration) <-
           Connector.handle_get(conn, "netRemote.play.info.duration") do
      Time.add(~T[00:00:00], duration, :millisecond)
    end
  end

  @doc """
  returns selected playing input mode
  """
  def get_mode(conn) do
    mode = Connector.handle_get(conn, "netRemote.sys.mode")
    Enum.find(get_modes(conn), fn %{"key" => key} -> key == mode end)
  end

  @doc """
  returns list of predefined equalizer modes
  """
  def get_eq_modes(conn) do
    Connector.handle_list(conn, "netRemote.sys.caps.eqPresets")
  end

  @doc """
  returns list of wifi networks
  """
  def get_wifi_scan(conn) do
    Connector.handle_list(conn, "netRemote.sys.net.wlan.scanList")
  end

  @doc """
  returns list of supported wifi modes
  """
  def get_modes(conn) do
    Connector.handle_list(conn, "netRemote.sys.caps.validModes")
  end

  @doc """
  TODO
  inits the radio
  """
  def init_radio(conn) do
    play_control(conn, :init)
  end

  @doc """
  play
  """
  def play(conn) do
    play_control(conn, :play)
  end

  @doc """
  pause
  """
  def pause(conn) do
    play_control(conn, :pause)
  end

  @doc """
  forward
  """
  def forward(conn) do
    play_control(conn, :forward)
  end

  @doc """
  rewind
  """
  def rewind(conn) do
    play_control(conn, :rewind)
  end

  @doc """
  play, pause, forward, rewind modes
  """
  def play_control(conn, value) do
    Connector.handle_set(conn, "netRemote.play.control", Constants.play_control(value))
  end

  @doc """
  sets volume in range returned by get_volume_steps
  """
  def set_volume(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.audio.volume", value)
  end

  @doc """
  sets device name
  """
  def set_friendly_name(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.info.friendlyName", value)
  end

  @doc """
  sets mute state
  """
  def set_mute(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.audio.mute", value)
  end

  @doc """
  sets power state
  """
  def set_power(conn, value) do
    Connector.handle_set(conn, "netRemote.sys.power", value)
  end

  @doc """
  sets current playack mode
  """
  def set_mode(conn, mode) do
    Connector.handle_set(conn, "netRemote.sys.mode", mode)
  end

  @doc """
  navigates to the the root node
  """
  def nav_reset(conn) do
    nav_to(conn, -1)
  end

  @doc """
  navigates inside a map
  map type is 0
  """
  def nav_to(conn, value) do
    Connector.handle_set(conn, "netRemote.nav.action.navigate", value)
  end

  @doc """
  selects current item to play
  map type is not 0
  """
  def nav_select(conn, value) do
    Connector.handle_set(conn, "netRemote.nav.action.selectItem", value)
  end

  @doc """
  navigates 1 level up
  """
  def nav_back(conn) do
    nav_to(conn, "0xffffffff")
  end

  @doc """
  TODO
  """
  def search(conn, value) do
    Connector.handle_set(conn, "netRemote.nav.searchTerm", value)
  end

  @doc """
  returns the number of items in current menu
  """
  def nav_num_items(conn) do
    Connector.handle_get(conn, "netRemote.nav.numItems")
  end

  @doc """
  returns items in current menu
  optional pagination params
  from = default -1
  items = default 100
  """
  def nav_menu(conn) do
    ExFrontier.Connector.handle_list(conn, "netRemote.nav.list")
  end

  @doc """
  returns status of the unit
  0 - loading
  1 - ready
  """
  def get_status(conn) do
    Connector.handle_get(conn, "netRemote.nav.status")
  end

  @doc """
  returns navigation state
  0 - disabled
  1 - enabled
  """
  def nav_state(conn) do
    Connector.handle_get(conn, "netRemote.nav.state")
  end

  @doc """
  disables navigation
  """
  def nav_disable(conn) do
    Connector.handle_set(conn, "netRemote.nav.state", 0)
  end

  @doc """
  enables navigation
  """
  def nav_enable(conn) do
    Connector.handle_set(conn, "netRemote.nav.state", 1)
  end

  @doc """
  returns notifications or timeouts if none are sent
  """
  def get_notifies(conn) do
    Connector.handle_get_notifies(conn)
  end
end
