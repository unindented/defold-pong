local fsm = require("shared.fsm")

describe("fsm", function ()

  describe("menu", function ()
    local menu

    before_each(function ()
      menu = fsm.create({
        initial = {state = "main_menu", event = "show_main_menu", defer = true},
        events = {
          {name = "show_settings_menu", from = "*", to = "settings_menu"},
          {name = "show_main_menu",     from = "*", to = "main_menu"    }
        },
        callbacks = {
          on_state = stub.new()
        }
      })
    end)

    it("starts at `none`", function ()
      assert.are_equal("none", menu.current)
    end)

    it("transitions to `main_menu`", function ()
      menu.show_main_menu()
      assert.are_equal("main_menu", menu.current)
    end)

    it("transitions to `settings_menu`", function ()
      menu.show_main_menu()
      menu.show_settings_menu()
      assert.are_equal("settings_menu", menu.current)
    end)

    it("transitions back to `main_menu`", function ()
      menu.show_main_menu()
      menu.show_settings_menu()
      menu.show_main_menu()
      assert.are_equal("main_menu", menu.current)
    end)

    it("fires callbacks", function ()
      menu.show_main_menu()
      assert.spy(menu.on_state).was_called()
    end)
  end)

end)
