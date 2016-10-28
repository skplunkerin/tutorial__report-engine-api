class User < ActiveRecord::Base
  attr_accessor             :password, :password_confirmation

  belongs_to                :engine
  has_many                  :properties
  has_and_belongs_to_many   :roles
  has_and_belongs_to_many   :properties

  validates_presence_of       :engine_id,
                              :on => :create
  validates_presence_of       :name,
                              :on => :create
  validates_presence_of       :status,
                              :on => :create
  validates_presence_of       :email
  validates_uniqueness_of     :email
  validates_format_of         :email,
                              :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                              :on => :create
  validates_presence_of       :password,
                              :on => :create
  validates_confirmation_of   :password
  validates_format_of         :password,
                              :with => /\A(?=.*[a-zA-Z]).{6,}\Z/,
                              :on => :create

  before_validation   :downcase_email
  before_create       :encrypt_password, :set_token
  before_update       :update_password_check

  def as_json(options={})
    super(
      :only => [
        :name, :email, :status, :notes, :apikey, :created_at
      ],
      :methods => [:permissions, :properties_owned, :properties_shared, :engine_apikey]
    )
  end

  def is_super_admin
    return self.permissions.include? 'api'
  end

  def is_admin
    return self.permissions.include? 'admin'
  end

  def is_reporter
    return self.permissions.include? 'reporter'
  end

  def is_client
    return self.permissions.include? 'client'
  end

  def owned_properties
    return Property.where({ user_id: self.id})
  end

  def shared_properties
    return self.properties
  end

  def permissions
    hashify = []
    self.roles.each do |r|
      hashify << r.name
    end
    return hashify.as_json
  end

  def properties_owned
    hashify = []
    Property.where({ user_id: self.id}).each do |p|
      hashify << {
        name: p.name,
        apikey: p.apikey
      }
    end
    return hashify.as_json
  end

  def properties_shared
    hashify = []
    self.properties.each do |p|
      hashify << {
        name: p.name,
        apikey: p.apikey
      }
    end
    return hashify.as_json
  end

  def engine_apikey
    return self.engine.apikey
  end

  private

  # http://stackoverflow.com/a/6422771/1180523
  def downcase_email
    self.email = email.downcase if email.present?
  end

  def update_password_check
    if password.present? && password_confirmation.present?
      encrypt_password
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def set_token
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while User.exists?(apikey: self.apikey)
  end
end
