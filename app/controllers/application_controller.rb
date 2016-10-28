class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter   :verify_token_access

  # Authorization: Token token=[ENGINE_APIKEY]:[USER_APIKEY]
  # Each endpoint will check for the ENGINE APIKEY, and USER APIKEY
  # - Is Engine active?
  # - Is User active?
  #   - What permissions does User have?
  def verify_token_access
    authenticate_or_request_with_http_token do |token, options|
      tokens = token.split(':') # "ENGINE_APIKEY:USER_APIKEY" => ["ENGINE_APIKEY","USER_APIKEY"]
      engine_key = tokens[0]
      user_key = tokens[1]
      engine_exists = Engine.exists?({apikey: engine_key, status: 'active'})
      user_exists = User.exists?({apikey: user_key, status: 'active'})
      if engine_exists && user_exists
        @access = true
        @current_engine_token = engine_key
        @current_user_token = user_key
        @current_user = User.find_by_apikey(user_key)
        @is_super_admin = @current_user.is_super_admin
        @is_admin = @current_user.is_admin
        @is_reporter = @current_user.is_reporter
        @is_client = @current_user.is_client
      else
        render json: { error: "Authorization Token: Access denied." }, status: 401
      end
    end
  end

  protected

  # Specify JSON response if issue with HTTP Token request
  # http://stackoverflow.com/a/18510100/1180523
  def request_http_token_authentication(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    if !@access
      render json: { error: "An unknown error occurred." }, status: 500
    end
  end
end
