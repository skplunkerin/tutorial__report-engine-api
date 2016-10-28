class Section < ActiveRecord::Base
  belongs_to    :report

  validates_presence_of       :report_id,
                              :on => :create
  validates_presence_of       :name,
                              :on => :create
  validates_presence_of       :status,
                              :on => :create

  before_create   :set_token

  def as_json(options={})
    super(
      :only => [
        :order, :name, :content, :apikey, :created_at
      ],  
      :methods => [:report_apikey]
    )   
  end 

  def report_apikey
    return self.report.apikey
  end 

  private

  def set_token
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while Section.exists?(apikey: self.apikey)
  end 
end
