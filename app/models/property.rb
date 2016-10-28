class Property < ActiveRecord::Base
  belongs_to                :engine
  belongs_to                :user
  has_many                  :reports
  has_and_belongs_to_many   :users

  validates_presence_of       :engine_id,
                              :on => :create
  validates_presence_of       :user_id,
                              :on => :create
  validates_presence_of       :name,
                              :on => :create
  validates_presence_of       :status,
                              :on => :create

  scope   :for_engine,    ->    (id) { where({engine_id: id}) }

  before_create   :set_token

  def as_json(options={})
    super(
      :only => [:name, :status, :notes, :apikey, :created_at],
      :methods => [:engine_apikey]    
    )
  end

  def engine_apikey
    return self.engine.apikey
  end

  private

  def set_token
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while Property.exists?(apikey: self.apikey)
  end
end
