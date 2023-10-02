require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }  # ここにletを追加

  describe "GET /destroy" do
    it "logs out the user" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
      expect(controller.current_user).to be_nil
    end
  end
end