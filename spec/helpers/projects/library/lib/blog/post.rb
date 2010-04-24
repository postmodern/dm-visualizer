require 'blog/user'

require 'dm-core'

module Blog
  class Post

    include DataMapper::Resource

    property :id, Serial

    property :title, String

    property :body, Text

    belongs_to :user

    has 0..n, :comments

  end
end
