require 'rails_helper'

RSpec.describe "Albums", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/albums/index"
      expect(response).to have_http_status(:success)
    end
  end

end
