module GraphqlApi
  module Post
    class Client
      QUERIES = [
        ['posts_query','POSTS_QUERY']
      ].freeze

      include ::GraphqlApi::ClientCommon

      def self.find(id)
        query_class = posts_query
        response = client.query(query_class, variables:{id: id})
        if response.errors.blank?
          response.data.post
        end
      end
    end
  end
end
