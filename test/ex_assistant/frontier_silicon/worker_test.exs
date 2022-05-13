defmodule ExAssistant.FrontierSilicon.WorkerTest do
  use ExUnit.Case, async: true

  import AssertValue
  alias FrontierSilicon.Worker

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

      assert {:ok, list} = Worker.parse_list(response)
      assert_value list == [
                     %{
                       "artist" => "",
                       "contextmenu" => "0",
                       "graphicuri" => "",
                       "key" => 0,
                       "name" => "Flow",
                       "subtype" => "3",
                       "type" => "1"
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => "0",
                       "graphicuri" => "",
                       "key" => 1,
                       "name" => "Charts",
                       "subtype" => "0",
                       "type" => "0"
                     },
                     %{
                       "artist" => "",
                       "contextmenu" => "0",
                       "graphicuri" => "",
                       "key" => 2,
                       "name" => "Recommendations",
                       "subtype" => "0",
                       "type" => "0"
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

      assert {:ok, list} = Worker.parse_list(response)
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

      assert {:ok, list} = Worker.parse_list(response)
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

      assert {:ok, list} = Worker.parse_list(response)
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

      assert {:ok, list} = Worker.parse_list(response)
      assert_value list == [
                     %{
                       "id" => "IR",
                       "key" => 0,
                       "label" => "Internet radio",
                       "modetype" => "0",
                       "selectable" => "1",
                       "streamable" => "1"
                     },
                     %{
                       "id" => "AIRABLE_TIDAL",
                       "key" => 1,
                       "label" => "TIDAL",
                       "modetype" => "0",
                       "selectable" => "1",
                       "streamable" => "1"
                     }
                   ]
    end
  end
end
