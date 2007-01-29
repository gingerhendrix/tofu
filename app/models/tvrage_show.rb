class TvrageShow < ActiveRecord::Base
  has_one :source, :class_name => "TvrageSource", :foreign_key => "child_id"
  belongs_to :show

end
