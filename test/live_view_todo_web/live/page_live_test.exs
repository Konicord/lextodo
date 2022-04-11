defmodule LiveViewTodoWeb.PageLiveTest do
  use LiveViewTodoWeb.ConnCase
  import Phoenix.LiveViewTest
  alias LiveViewTodo.Item

  test "disconnected and connected mount", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Todo"
    assert render(page_live) =~ "What needs to be done"
  end

  test "connect and create a todo item", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_submit(view, :create, %{"text" => "Learn Elixir"}) =~ "Learn Elixir"
  end

  test "toggle an item", %{conn: conn} do
    {:ok, item} = Item.create_item(%{"text" => "Learn Elixir"})
    assert item.status == 0

    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :toggle, %{"id" => item.id, "value" => 1}) =~ "completed"

    updated_item = Item.get_item!(item.id)
    assert updated_item.status == 1
  end

  test "delete an item", %{conn: conn} do
    {:ok, item} = Item.create_item(%{"text" => "Learn Elixir"})
    assert item.status == 0

    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :delete, %{"id" => item.id})

    updated_item = Item.get_item!(item.id)
    assert updated_item.status == 2
  end
end
