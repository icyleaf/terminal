require "../spec_helper"

describe Terminal::UI do
  describe "#new" do
    it "should return a default ui" do
      ui = Terminal::UI.new
      ui.should be_a Terminal::UI
    end
  end
end
