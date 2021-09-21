class Post
  def self.client
    GraphqlApi::Post::Client
  end

  def self.find(id)
    client.find(id)
  end
end
