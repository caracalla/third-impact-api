class User::AuthenticationSerializer < ActiveModel::Serializer
  attributes  :id,
              :username,
              :email,
              :admin,
              :auth_token
end
