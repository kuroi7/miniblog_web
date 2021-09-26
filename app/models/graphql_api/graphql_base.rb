require 'graphql/client'
require 'graphql/client/http'
require 'singleton'

module GraphqlApi
  module GraphqlBase
    class ClientSingleton
      include Singleton
      attr_accessor :client

      def initialize
        http = GraphQL::Client::HTTP.new(Settings.api_url) do
          def headers(_context) # rubocop:disable Lint/NestedMethodDefinition
            # Optionally set any HTTP headers.
            { 'User-Agent': 'Frontend GraphQL Client' }
          end
        end
        schema = GraphQL::Client.load_schema(http)
        @client = GraphQL::Client.new(schema: schema, execute: http)
      end
    end
  end
end
