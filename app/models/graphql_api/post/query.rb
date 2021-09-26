module GraphqlApi
  module Post
    class Query
      POSTS_QUERY = <<-GRAPHQL.freeze
        query($id: ID!) {
            post(id: $id) {
              id
              title
              comments {
                id
                content
              }
            }
          }
      GRAPHQL
    end
  end
end
