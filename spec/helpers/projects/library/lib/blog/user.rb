require 'blog/post'

require 'dm-core'

module Blog
  class User

    include DataMapper::Resource

    property :id, Serial

    property :name, String

    has 0..n, :posts

  end
end
