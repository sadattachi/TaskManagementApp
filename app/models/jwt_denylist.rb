# frozen_string_literal: true

# Service model for devise-jwt for jwt token revocation
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'
end
