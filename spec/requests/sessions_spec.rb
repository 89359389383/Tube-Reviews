require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /destroy" do
    it "logs out the user" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(unauthenticated_root_path) # 修正箇所
      expect(controller.current_user).to be_nil
    end
  end
end
