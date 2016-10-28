class Engine < ActiveRecord::Base
  has_many    :properties
  has_many    :users

  validates_presence_of       :name,
                              :on => :create
  validates_presence_of       :status,
                              :on => :create

  before_create   :set_token

  scope   :for_token,    ->    (token) { where({apikey: token}).first }
  scope   :is_active,   ->    { where(status: "active") }
  scope   :in_review,   ->    { where(status: "reviewing") }
  scope   :is_deleted,  ->    { where(status: "deleted") }
  scope   :not_deleted,  ->    { where.not(status: "deleted") }

  def as_json(options={})
    json = super(
      :only => [:name, :status, :apikey, :created_at]
    )
    # Ability to add key / value to response (Engine.all.as_json({properties: true}))
    if !options[:properties].nil?
      json[:properties] = self.properties.as_json
    end
    return json
  end

  def self.as_json_with_properties
    hashify = {
      engines: []
    }
    Engine.not_deleted.each do |e|
      hash = e.as_json
      hash["properties"] = e.properties.as_json
      hashify[:engines] << hash
    end
    return hashify.as_json
  end

  private

  def set_token
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while Engine.exists?(apikey: self.apikey)
  end
end
