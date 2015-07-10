class Comment

  include DataMapper::Resource

  property :id, Serial

  property :body, Text

  belongs_to :post

end
