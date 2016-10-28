class Report < ActiveRecord::Base
  belongs_to    :property
  has_many      :sections

  validates_presence_of       :property_id,
                              :on => :create
  validates_presence_of       :name,
                              :on => :create
  validates_presence_of       :status,
                              :on => :create

  before_create   :set_token   

  def as_json(options={})      
    super(
      :only => [
        :name, :summary, :version, :status, :publish_date,
        :notes, :initial_viewed_date, :view_count, :apikey,
        :apikey, :created_at
      ],
      :methods => [:property_apikey]
    )
  end

  def property_apikey
    return self.property.apikey
  end

  private

  def set_token
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while Report.exists?(apikey: self.apikey)
  end
end
