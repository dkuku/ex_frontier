defmodule ExFrontier.ParserTest do
  use ExUnit.Case, async: true

  import AssertValue

  alias ExFrontier.Parser

  describe "parse_list/2" do
    test "Deezer response" do
      response = """
      <fsapiResponse>
        <status>FS_OK</status>
        <item key="0">
          <field name="name"><c8_array>Flow</c8_array></field>
          <field name="type"><u8>1</u8></field>
          <field name="subtype"><u8>3</u8></field>
          <field name="graphicuri"><c8_array></c8_array></field>
          <field name="artist"><c8_array></c8_array></field>
          <field name="contextmenu"><u8>0</u8></field>
        </item>
        <item key="1">
          <field name="name"><c8_array>Charts</c8_array></field>
          <field name="type"><u8>0</u8></field>
          <field name="subtype"><u8>0</u8></field>
          <field name="graphicuri"><c8_array></c8_array></field>
          <field name="artist"><c8_array></c8_array></field>
          <field name="contextmenu"><u8>0</u8></field>
        </item>
        <item key="2">
          <field name="name"><c8_array>Recommendations</c8_array></field>
          <field name="type"><u8>0</u8></field>
          <field name="subtype"><u8>0</u8></field>
          <field name="graphicuri"><c8_array></c8_array></field>
          <field name="artist"><c8_array></c8_array></field>
          <field name="contextmenu"><u8>0</u8></field>
        </item>
        <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 0,
                       "name" => "Flow",
                       "subtype" => 3,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 1,
                       "name" => "Charts",
                       "subtype" => 0,
                       "type" => 0
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 2,
                       "name" => "Recommendations",
                       "subtype" => 0,
                       "type" => 0
                     }
                   ]
    end

    test "radio response" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <item key="0">
      <field name="name"><c8_array>ROCK ANTENNE</c8_array></field>
      <field name="type"><u8>0</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="1">
      <field name="name"><c8_array>ROCK ANTENNE Bayern</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="2">
      <field name="name"><c8_array>ROCK ANTENNE Österreich</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="3">
      <field name="name"><c8_array>ROCK ANTENNE Rock &apos;n&apos; Roll</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="4">
      <field name="name"><c8_array>ROCK ANTENNE Live Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="5">
      <field name="name"><c8_array>ROCK ANTENNE Lagerfeuer Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="6">
      <field name="name"><c8_array>ROCK ANTENNE 80er Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="7">
      <field name="name"><c8_array>ROCK ANTENNE Symphonic Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="8">
      <field name="name"><c8_array>ROCK ANTENNE 70er Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="9">
      <field name="name"><c8_array>ROCK ANTENNE Biker Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="10">
      <field name="name"><c8_array>ROCK ANTENNE 90er Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="11">
      <field name="name"><c8_array>ROCK ANTENNE Xmas Rock</c8_array></field>
      <field name="type"><u8>1</u8></field>
      <field name="subtype"><u8>1</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 0,
                       "name" => "ROCK ANTENNE",
                       "subtype" => 0,
                       "type" => 0
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 1,
                       "name" => "ROCK ANTENNE Bayern",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 2,
                       "name" => "ROCK ANTENNE Österreich",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 3,
                       "name" => "ROCK ANTENNE Rock 'n' Roll",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 4,
                       "name" => "ROCK ANTENNE Live Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 5,
                       "name" => "ROCK ANTENNE Lagerfeuer Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 6,
                       "name" => "ROCK ANTENNE 80er Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 7,
                       "name" => "ROCK ANTENNE Symphonic Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 8,
                       "name" => "ROCK ANTENNE 70er Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 9,
                       "name" => "ROCK ANTENNE Biker Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 10,
                       "name" => "ROCK ANTENNE 90er Rock",
                       "subtype" => 1,
                       "type" => 1
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 11,
                       "name" => "ROCK ANTENNE Xmas Rock",
                       "subtype" => 1,
                       "type" => 1
                     }
                   ]
    end

    test "radio sub response after 0xffffffff" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <item key="0">
      <field name="name"><c8_array>Location</c8_array></field>
      <field name="type"><u8>0</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="1">
      <field name="name"><c8_array>Genre</c8_array></field>
      <field name="type"><u8>0</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="2">
      <field name="name"><c8_array>Search stations</c8_array></field>
      <field name="type"><u8>2</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="3">
      <field name="name"><c8_array>Popular stations</c8_array></field>
      <field name="type"><u8>0</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <item key="4">
      <field name="name"><c8_array>New stations</c8_array></field>
      <field name="type"><u8>0</u8></field>
      <field name="subtype"><u8>0</u8></field>
      <field name="graphicuri"><c8_array></c8_array></field>
      <field name="artist"><c8_array></c8_array></field>
      <field name="contextmenu"><u8>0</u8></field>

      </item>
      <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 0,
                       "name" => "Location",
                       "subtype" => 0,
                       "type" => 0
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 1,
                       "name" => "Genre",
                       "subtype" => 0,
                       "type" => 0
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 2,
                       "name" => "Search stations",
                       "subtype" => 0,
                       "type" => 2
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 3,
                       "name" => "Popular stations",
                       "subtype" => 0,
                       "type" => 0
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => 0,
                       "graphicuri" => "",
                       "key" => 4,
                       "name" => "New stations",
                       "subtype" => 0,
                       "type" => 0
                     }
                   ]
    end

    test "response" do
      response = """
      <fsapiResponse>
        <status>FS_OK</status>
        <item key="0">
          <field name="name"><c8_array>The Game Is On</c8_array></field>
          <field name="type"><c8_array>Deezer</c8_array></field>
        </item>
        <item key="1">
          <field name="name"><c8_array></c8_array></field>
          <field name="type"><c8_array></c8_array></field>
        </item>
        <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{"key" => 0, "name" => "The Game Is On", "type" => "Deezer"},
                     %{"key" => 1, "name" => "", "type" => ""}
                   ]
    end

    test "equalizer response" do
      response = """
      <fsapiResponse>
        <status>FS_OK</status>
        <item key="0">
          <field name="label"><c8_array>Normal</c8_array></field>
        </item>
        <item key="1">
          <field name="label"><c8_array>Flat</c8_array></field>
        </item>
        <item key="2">
          <field name="label"><c8_array>Music</c8_array></field>
        </item>
        <item key="3">
          <field name="label"><c8_array>Bass Boost</c8_array></field>
        </item>
        <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{"key" => 0, "label" => "Normal"},
                     %{"key" => 1, "label" => "Flat"},
                     %{"key" => 2, "label" => "Music"},
                     %{"key" => 3, "label" => "Bass Boost"}
                   ]
    end

    test "language response" do
      response = """
      <fsapiResponse>
        <status>FS_OK</status>
        <item key="0">
          <field name="langlabel"><c8_array>English</c8_array></field>
        </item>
        <item key="1">
          <field name="langlabel"><c8_array>Danish</c8_array></field>
        </item>
        <item key="2">
          <field name="langlabel"><c8_array>Dutch</c8_array></field>
        </item>
        <item key="3">
          <field name="langlabel"><c8_array>Finnish</c8_array></field>
        </item>
        <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{"key" => 0, "langlabel" => "English"},
                     %{"key" => 1, "langlabel" => "Danish"},
                     %{"key" => 2, "langlabel" => "Dutch"},
                     %{"key" => 3, "langlabel" => "Finnish"}
                   ]
    end

    test "input response" do
      response = """
      <fsapiResponse>
        <status>FS_OK</status>
        <item key="0">
          <field name="id"><c8_array>IR</c8_array></field>
          <field name="selectable"><u8>1</u8></field>
          <field name="label"><c8_array>Internet radio</c8_array></field>
          <field name="streamable"><u8>1</u8></field>
          <field name="modetype"><u8>0</u8></field>
        </item>
        <item key="1">
          <field name="id"><c8_array>AIRABLE_TIDAL</c8_array></field>
          <field name="selectable"><u8>1</u8></field>
          <field name="label"><c8_array>TIDAL</c8_array></field>
          <field name="streamable"><u8>1</u8></field>
          <field name="modetype"><u8>0</u8></field>
        </item>
        <listend/>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_list(response)

      assert_value list == [
                     %{
                       "id" => "IR",
                       "key" => 0,
                       "label" => "Internet radio",
                       "modetype" => 0,
                       "selectable" => 1,
                       "streamable" => 1
                     },
                     %{
                       "id" => "AIRABLE_TIDAL",
                       "key" => 1,
                       "label" => "TIDAL",
                       "modetype" => 0,
                       "selectable" => 1,
                       "streamable" => 1
                     }
                   ]
    end
  end

  describe "handle_set_multiple" do
    test "basic test" do
      response = """
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
      """

      assert {:ok, list} = Parser.parse_set_multiple(response)

      assert_value list == %{
                     "netRemote.nav.action.navigate" => :ok,
                     "netRemote.nav.searchTerm" => :ok
                   }
    end
  end

  describe "handle_get_multiple" do
    test "basic test" do
      response = """
      <fsapiGetMultipleResponse>
        <fsapiResponse>
          <node>netRemote.sys.sleep</node>
          <status>FS_OK</status>
          <value><u32>0</u32></value>
        </fsapiResponse>
        <fsapiResponse>
          <node>netRemote.sys.power</node>
          <status>FS_OK</status>
          <value><u8>0</u8></value>
        </fsapiResponse>
      </fsapiGetMultipleResponse>
      """

      assert {:ok, list} = Parser.parse_get_multiple(response)

      assert_value list == %{"netRemote.sys.power" => 0, "netRemote.sys.sleep" => 0}
    end

    test "with error" do
      response = """
      <fsapiGetMultipleResponse>
        <fsapiResponse>
          <node>netRemote.sys.sleep</node>
          <status>FS_OK</status>
          <value><u32>0</u32></value>
        </fsapiResponse>
        <fsapiResponse>
          <node>netRemote.sys</node>
          <status>FS_NODE_DOES_NOT_EXIST</status>
          </fsapiResponse>
      </fsapiGetMultipleResponse>
      """

      assert {:ok, list} = Parser.parse_get_multiple(response)

      assert_value list == %{"netRemote.sys" => {:error, :not_exist}, "netRemote.sys.sleep" => 0}
    end
  end

  describe "handle_get" do
    test "c8_array" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <value><c8_array>00:22:61:f6:d6:62</c8_array></value>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_response(response)
      assert_value list == "00:22:61:f6:d6:62"
    end

    test "s32" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <value><s32>8</s32></value>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_response(response)
      assert_value list == 8
    end

    test "u32" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <value><u32>4294967040</u32></value>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_response(response)
      assert_value list == 4_294_967_040
    end

    test "u8" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <value><u8>64</u8></value>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_response(response)
      assert_value list == 64
    end
  end

  describe "handle_get_notifies" do
    test "netremote.play.info.text" do
      response = """
      <fsapiResponse>
      <status>FS_OK</status>
      <notify node="netremote.play.info.text"><value><c8_array>Arthur Brown - Fire</c8_array></value>
      </notify>
      </fsapiResponse>
      """

      assert {:ok, list} = Parser.parse_get_notifies(response)
      assert_value list == %{"netremote.play.info.text" => "Arthur Brown - Fire"}
    end
  end

  test "int_to_ip" do
    assert_value Parser.int_to_ip(3_232_235_927) == "192.168.1.151"
    assert_value Parser.int_to_ip(3_232_235_777) == "192.168.1.1"
    assert_value Parser.int_to_ip(4_294_967_040) == "255.255.255.0"
  end
end
