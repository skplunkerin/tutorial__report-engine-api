class Role < ActiveRecord::Base
  has_and_belongs_to_many   :users

  validates_presence_of       :name,
                              :on => :create

  def as_json(options={})
    super(
      :only => [:name]
    )   
  end 
end
