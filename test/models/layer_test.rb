require 'test_helper'

class LayerTest < ActiveSupport::TestCase
  test "should not save" do
    o = Layer.new
    assert_not o.save, "Saved without required fields"
  end
end
