defmodule ExFrontier.ConnectorTest do
  use ExUnit.Case, async: true

  import AssertValue
  import Hammox

  alias ExFrontier.Connector

  setup_all do
    conn = %{
      friendly_name: "speaker",
      session_id: "96716244",
      version: "ir-mmi-FS2026-0500-0487_V2.14.33.EX85161-2RC12",
      webfsapi: "http://192.168.1.151:80/fsapi"
    }

    [conn: conn]
  end

  test "connect" do
    mock_request("""
    <netRemote>
    <friendlyName>speaker</friendlyName>
    <version>ir-mmi-FS2026-0500-0487_V2.14.33.EX85161-2RC12</version>
    <webfsapi>http://192.168.1.151:80/fsapi</webfsapi>
    </netRemote>
    """)

    mock_request("""
    <fsapiResponse>
    <status>FS_OK</status>
    <sessionId>96716244</sessionId>
    </fsapiResponse>
    """)

    assert_value Connector.connect() ==
                   %ExFrontier.Conn{
                     friendly_name: "speaker",
                     session_id: "96716244",
                     version: "ir-mmi-FS2026-0500-0487_V2.14.33.EX85161-2RC12",
                     webfsapi: "http://192.168.1.151:80/fsapi"
                   }
  end

  test "handle_get", %{conn: conn} do
    mock_request("""
    <fsapiResponse>
    <status>FS_OK</status>
    <value><c8_array>ROCK ANTENNE</c8_array></value>
    </fsapiResponse>
    """)

    response = Connector.handle_get(conn, "netRemote.play.info.name")
    assert_value response == "ROCK ANTENNE"
  end

  test "handle_set", %{conn: conn} do
    mock_request("""
    <fsapiResponse>
    <status>FS_OK</status>
    </fsapiResponse>
    """)

    response = Connector.handle_set(conn, "netRemote.play.info.name", "speaker")
    assert_value response == :ok
  end

  test "handle_set_multiple", %{conn: conn} do
    mock_request("""
    <fsapiSetMultipleResponse>
    <fsapiResponse>
    <node>netRemote.nav.searchTerm</node>
    <status>FS_OK</status>
    </fsapiResponse>
    <fsapiResponse>
    <node>netRemote.nav.action.navigate</node>
    <status>FS_OK</status>
    </fsapiResponse>
    </fsapiSetMultipleResponse>
    """)

    response =
      Connector.handle_set_multiple(conn, [
        "netRemote.nav.searchTerm",
        "antyradio",
        "netRemote.nav.action.navigate",
        "1"
      ])

    assert_value response ==
                   {:ok, %{"netRemote.nav.action.navigate" => :ok, "netRemote.nav.searchTerm" => :ok}}
  end

  test "handle_get_multiple", %{conn: conn} do
    mock_request("""
    <fsapiGetMultipleResponse>
    <fsapiResponse>
    <node>netRemote.sys.info.version</node>
    <status>FS_OK</status>
    <value><c8_array>ir-mmi-FS2026-0500-0487_V2.14.33.EX85161-2RC12</c8_array></value>
    </fsapiResponse>
    <fsapiResponse>
    <node>netRemote.sys.info.radioId</node>
    <status>FS_OK</status>
    <value><c8_array>002261F6D662</c8_array></value>
    </fsapiResponse>
    </fsapiGetMultipleResponse>
    """)

    response =
      Connector.handle_get_multiple(conn, [
        "netRemote.play.info.version",
        "netRemote.play.info.radioId"
      ])

    assert_value response ==
                   {:ok,
                    %{
                      "netRemote.sys.info.radioId" => "002261F6D662",
                      "netRemote.sys.info.version" => "ir-mmi-FS2026-0500-0487_V2.14.33.EX85161-2RC12"
                    }}
  end

  test "handle_get_notifies", %{conn: conn} do
    mock_request("""
    <fsapiResponse>
    <status>FS_OK</status>
    <notify node="netremote.play.info.text">
    <value><c8_array>Rammstein - Zeit</c8_array></value>
    </notify>
    </fsapiResponse>
    """)

    response = Connector.handle_get_notifies(conn)

    assert_value response == {:ok, %{"netremote.play.info.text" => "Rammstein - Zeit"}}
  end

  test "handle_list", %{conn: conn} do
    mock_request("""
    <fsapiResponse>
    <status>FS_OK</status>
    <item key="0">
    <field name="name"><c8_array>ROCK ANTENNE</c8_array></field>
    <field name="type"><u8>1</u8></field>
    <field name="subtype"><u8>1</u8></field>
    <field name="graphicuri"><c8_array></c8_array></field>
    <field name="artist"><c8_array></c8_array></field>
    <field name="contextmenu"><u8>0</u8></field>

    </item>
    <item key="1">
    <field name="name"><c8_array>Podcasts</c8_array></field>
    <field name="type"><u8>0</u8></field>
    <field name="subtype"><u8>0</u8></field>
    <field name="graphicuri"><c8_array></c8_array></field>
    <field name="artist"><c8_array></c8_array></field>
    <field name="contextmenu"><u8>0</u8></field>

    </item>
    <listend/>
    </fsapiResponse>
    """)

    response = Connector.handle_list(conn, "netRemote.nav.list")

    assert_value response == [
                   %{
                     "artist" => "",
                     "contextmenu" => 0,
                     "graphicuri" => "",
                     "key" => 0,
                     "name" => "ROCK ANTENNE",
                     "subtype" => 1,
                     "type" => 1
                   },
                   %{
                     "artist" => "",
                     "contextmenu" => 0,
                     "graphicuri" => "",
                     "key" => 1,
                     "name" => "Podcasts",
                     "subtype" => 0,
                     "type" => 0
                   }
                 ]
  end

  defp mock_request(body) do
    expect(
      ExFrontier.Tesla.Mock,
      :call,
      fn %{url: url}, _opts ->
        {:ok,
         %Tesla.Env{
           __client__: %Tesla.Client{adapter: nil, fun: nil, post: [], pre: []},
           __module__: ExFrontier.Connector,
           body: body,
           headers: [
             {"content-type", "text/xml"},
             {"access-control-allow-origin", "*"},
             {"content-length", "179"}
           ],
           method: :get,
           opts: [],
           query: [],
           status: 200,
           url: url
         }}
      end
    )
  end
end
