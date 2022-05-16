[1mdiff --git a/config/test.exs b/config/test.exs[m
[1mindex cef1623..d71583d 100644[m
[1m--- a/config/test.exs[m
[1m+++ b/config/test.exs[m
[36m@@ -33,4 +33,4 @@[m [mconfig :ex_unit, timeout: :infinity[m
 # Initialize plugs at runtime for faster test compilation[m
 config :phoenix, :plug_init_mode, :runtime[m
 [m
[31m-config :tesla, adapter: FrontierSilicon.Tesla.Mock[m
[32m+[m[32mconfig :tesla, adapter: ExFrontierSilicon.Tesla.Mock[m
[1mdiff --git a/lib/ex_assistant/frontier_silicon/connector.ex b/lib/ex_assistant/frontier_silicon/connector.ex[m
[1mindex a0d5b33..611c1a0 100644[m
[1m--- a/lib/ex_assistant/frontier_silicon/connector.ex[m
[1m+++ b/lib/ex_assistant/frontier_silicon/connector.ex[m
[36m@@ -1,7 +1,7 @@[m
[31m-defmodule FrontierSilicon.Connector do[m
[32m+[m[32mdefmodule ExFrontierSilicon.Connector do[m
   use Tesla[m
[31m-  alias FrontierSilicon.Constants[m
[31m-  alias FrontierSilicon.Parser[m
[32m+[m[32m  alias ExFrontierSilicon.Constants[m
[32m+[m[32m  alias ExFrontierSilicon.Parser[m
 [m
   @url "http://192.168.1.151:80/device"[m
   @max_get_multiple_count 10[m
[1mdiff --git a/lib/ex_assistant/frontier_silicon/constants.ex b/lib/ex_assistant/frontier_silicon/constants.ex[m
[1mindex 6885bdd..f4c3e8d 100644[m
[1m--- a/lib/ex_assistant/frontier_silicon/constants.ex[m
[1m+++ b/lib/ex_assistant/frontier_silicon/constants.ex[m
[36m@@ -1,4 +1,4 @@[m
[31m-defmodule FrontierSilicon.Constants do[m
[32m+[m[32mdefmodule ExFrontierSilicon.Constants do[m
   @net_remote_play_states %{[m
     0 => :stopped,[m
     1 => :unknown,[m
[1mdiff --git a/lib/ex_assistant/frontier_silicon/parser.ex b/lib/ex_assistant/frontier_silicon/parser.ex[m
[1mindex 4d66666..26f8b31 100644[m
[1m--- a/lib/ex_assistant/frontier_silicon/parser.ex[m
[1m+++ b/lib/ex_assistant/frontier_silicon/parser.ex[m
[36m@@ -1,4 +1,4 @@[m
[31m-defmodule FrontierSilicon.Parser do[m
[32m+[m[32mdefmodule ExFrontierSilicon.Parser do[m
   import SweetXml[m
   def postprocess_response(value, :array, _item), do: Base.decode16!(String.upcase(value))[m
 [m
[1mdiff --git a/lib/ex_assistant_web/controllers/page_controller.ex b/lib/ex_assistant_web/controllers/page_controller.ex[m
[1mindex 4983435..4489dd9 100644[m
[1m--- a/lib/ex_assistant_web/controllers/page_controller.ex[m
[1m+++ b/lib/ex_assistant_web/controllers/page_controller.ex[m
[36m@@ -1,9 +1,9 @@[m
 defmodule ExAssistantWeb.PageController do[m
   use ExAssistantWeb, :controller[m
[31m-  alias FrontierSilicon.Constants[m
[32m+[m[32m  alias ExFrontierSilicon.Constants[m
 [m
   def index(conn, _params) do[m
[31m-    connection = FrontierSilicon.Connector.connect()[m
[32m+[m[32m    connection = ExFrontierSilicon.Connector.connect()[m
 [m
     params =[m
       Constants.get()[m
[36m@@ -25,7 +25,7 @@[m [mdefmodule ExAssistantWeb.PageController do[m
   defp get_list(connection, param) do[m
     try do[m
       connection[m
[31m-      |> FrontierSilicon.Connector.handle_list(param)[m
[32m+[m[32m      |> ExFrontierSilicon.Connector.handle_list(param)[m
     rescue[m
       error ->[m
         IO.inspect(error)[m
[36m@@ -37,8 +37,8 @@[m [mdefmodule ExAssistantWeb.PageController do[m
     try do[m
       {:ok, params} =[m
         connection[m
[31m-        |> FrontierSilicon.Connector.handle_get_multiple(params)[m
[31m-        |> FrontierSilicon.Parser.parse_get_multiple()[m
[32m+[m[32m        |> ExFrontierSilicon.Connector.handle_get_multiple(params)[m
[32m+[m[32m        |> ExFrontierSilicon.Parser.parse_get_multiple()[m
 [m
       params[m
     rescue[m
[1mdiff --git a/test/ex_assistant/frontier_silicon/connector_test.exs b/test/ex_assistant/frontier_silicon/connector_test.exs[m
[1mindex 847e47a..b2738be 100644[m
[1m--- a/test/ex_assistant/frontier_silicon/connector_test.exs[m
[1m+++ b/test/ex_assistant/frontier_silicon/connector_test.exs[m
[36m@@ -1,9 +1,9 @@[m
[31m-defmodule FrontierSilicon.ConnectorTest do[m
[32m+[m[32mdefmodule ExFrontierSilicon.ConnectorTest do[m
   use ExUnit.Case, async: true[m
   import AssertValue[m
   import Hammox[m
 [m
[31m-  alias FrontierSilicon.Connector[m
[32m+[m[32m  alias ExFrontierSilicon.Connector[m
 [m
   setup_all do[m
     conn = %{[m
[36m@@ -153,13 +153,13 @@[m [mdefmodule FrontierSilicon.ConnectorTest do[m
 [m
   defp mock_request(body) do[m
     expect([m
[31m-      FrontierSilicon.Tesla.Mock,[m
[32m+[m[32m      ExFrontierSilicon.Tesla.Mock,[m
       :call,[m
       fn %{url: url}, _opts ->[m
         {:ok,[m
          %Tesla.Env{[m
            __client__: %Tesla.Client{adapter: nil, fun: nil, post: [], pre: []},[m
[31m-           __module__: FrontierSilicon.Connector,[m
[32m+[m[32m           __module__: ExFrontierSilicon.Connector,[m
            body: body,[m
            headers: [[m
              {"content-type", "text/xml"},[m
[1mdiff --git a/test/ex_assistant/frontier_silicon/parser_test.exs b/test/ex_assistant/frontier_silicon/parser_test.exs[m
[1mindex 809b471..cb542e1 100644[m
[1m--- a/test/ex_assistant/frontier_silicon/parser_test.exs[m
[1m+++ b/test/ex_assistant/frontier_silicon/parser_test.exs[m
[36m@@ -1,8 +1,8 @@[m
[31m-defmodule ExAssistant.FrontierSilicon.ParserTest do[m
[32m+[m[32mdefmodule ExAssistant.ExFrontierSilicon.ParserTest do[m
   use ExUnit.Case, async: true[m
 [m
   import AssertValue[m
[31m-  alias FrontierSilicon.Parser[m
[32m+[m[32m  alias ExFrontierSilicon.Parser[m
 [m
   describe "parse_list/2" do[m
     test "Deezer response" do[m
[1mdiff --git a/test/support/mocks.ex b/test/support/mocks.ex[m
[1mindex e800cd4..4d1931f 100644[m
[1m--- a/test/support/mocks.ex[m
[1m+++ b/test/support/mocks.ex[m
[36m@@ -1 +1 @@[m
[31m-Hammox.defmock(FrontierSilicon.Tesla.Mock, for: Tesla.Adapter)[m
[32m+[m[32mHammox.defmock(ExFrontierSilicon.Tesla.Mock, for: Tesla.Adapter)[m
