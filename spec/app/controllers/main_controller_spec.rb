require 'spec_helper'

RSpec.describe "/main" do
    before do
      get "/"
    end

    it "render index page" do
      expect(response).to render_template("index.html")
    end

end
