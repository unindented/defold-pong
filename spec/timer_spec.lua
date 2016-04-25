local timer = require "shared.timer"

describe("timer", function()

  describe("#frames", function()
    it("invokes the callbacks after the specified number of frames", function()
      local cb1 = stub.new()
      local cb2 = stub.new()
      timer.frames(2, cb2)
      timer.frames(3, cb1)

      timer.update(10)
      assert.stub(cb1).was_not_called()
      assert.stub(cb2).was_not_called()

      timer.update(10)
      assert.stub(cb1).was_not_called()
      assert.stub(cb2).was_called(1)

      timer.update(10)
      assert.stub(cb1).was_called(1)
      assert.stub(cb2).was_called(1)
    end)
  end)

  describe("#seconds", function()
    it("invokes the callbacks after the specified number of seconds", function()
      local cb1 = stub.new()
      local cb2 = stub.new()
      timer.seconds(20, cb2)
      timer.seconds(30, cb1)

      timer.update(10)
      assert.stub(cb1).was_not_called()
      assert.stub(cb2).was_not_called()

      timer.update(10)
      assert.stub(cb1).was_not_called()
      assert.stub(cb2).was_called(1)

      timer.update(10)
      assert.stub(cb1).was_called(1)
      assert.stub(cb2).was_called(1)
    end)
  end)

  describe("#cancel_all", function()
    it("cancels all timers", function()
      local cb1 = stub.new()
      local cb2 = stub.new()
      timer.frames(2, cb2)
      timer.seconds(30, cb1)

      timer.cancel_all()
      timer.update(30)
      assert.stub(cb1).was_not_called()
      assert.stub(cb2).was_not_called()
    end)
  end)

end)
