module GraphqlApi
  module Post
    class query
      POSTS_QUERY = <<-GRAPHQL.freeze
        query($id: ID!) {
          selfPost {
            posts {
              id
              title
              comments {
                id
                content
              }
            }
          }
        }
      GRAPHQL
    end
  end
end
