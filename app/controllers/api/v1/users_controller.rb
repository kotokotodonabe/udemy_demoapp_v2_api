class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    # ハッシュ形式でJsonを返す
    render json: users.as_json(only: [:id, :name, :email, :created_at])
  end
end
