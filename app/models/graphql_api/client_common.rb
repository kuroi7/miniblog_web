module GraphqlApi
  module ClientCommon
    extend ActiveSupport::Concern

    included do # rubocop:disable Metrics/BlockLength
      # NOTE: QUERIESという名前で、
      #       [ #{定数定義兼定数取得用のメソッド名}, #{クエリ名定数名} ]の配列 をinclude元のクラスで定義する。
      #
      # (例)
      #
      #   QUERIES = [
      #     ['index_items_query', 'INDEX'],
      #     ['create_mutation', 'CREATE']
      #   ]
      #
      # (具体例)
      #   以下の条件下では、下記のようなメソッドが定義されることになる。
      #
      #   - include元がGraphqlApi::FavoriteItemGroup::Clientクラス
      #   - QUERIES = [['index_items_query', 'INDEX']] が定義済み
      #
      #
      #   private def self.index_items_query
      #     return IndexItemsQuery if defined? IndexItemsQuery
      #
      #     const_set(:IndexItemsQuery, client.parse(GraphqlApi::FavoriteItemGroup::Query::INDEX))
      #   end

      self::QUERIES.each do |constname, queryname|
        define_singleton_method constname do
          const = constname.camelize
          return const_get(const) if const_defined? const

          const_set(const, client.parse(module_parent::Query.const_get(queryname)))
        end
        singleton_class.send(:private, constname)
      end

      class << self
        private def response(api_response, response_class: nil)
          self::Response.new(
            response_class: response_class,
            api_response: api_response
          )
        end

        private def client
          client = GraphqlApi::GraphqlBase::ClientSingleton.instance.client
          Rails.env.development? ? DebugClient.new(client) : client
        end

        class DebugClient
          def initialize(origin)
            @origin = origin
          end

          def query(*args)
            @origin.query(*args).tap { DebugSession.register_graphql_response(_1) }
          end

          def method_missing(name, *args) # rubocop:disable Style/MethodMissingSuper
            @origin.send(name, *args)
          end

          def respond_to_missing?(symbol, include_private)
            @origin.respond_to_missing?(symbol, include_private)
          end
        end
      end

      class Response
        def initialize(response_class:, api_response:)
          response_class ||= ::GraphqlApi::Response
          @response = response_class.new(api_response)
          check_response
        end

        attr_reader :response

        def check_response
          return if response.success?

          response.logger(response.errors)
        end

        def success?
          response.success?
        end
      end
    end
  end
end
