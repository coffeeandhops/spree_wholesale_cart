module Spree
  module Api
    module V2
      module Storefront
        class WholesalersController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers

          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          def show
            render_serialized_payload { serialize_resource(resource) }
          end

          private

          # def serialize_wholesaler(wholesaler)
          #   Spree::V2::Storefront::GiftCardSerializer.new(wholesaler, include: resource_includes, fields: sparse_fields).serializable_hash
          # end

          # def render_wholesaler(result)
          #   if result.success?
          #     render_serialized_payload { serialized_current_order }
          #   else
          #     render_error_payload(result.error)
          #   end
          # end

          # THIS HAS BEEN MOVED TO BASE CONTROLLER
          def serialize_resource(resource)
            resource_serializer.new(
              resource,
              include: resource_includes,
              fields: sparse_fields
            ).serializable_hash
          end

          def serialize_collection(collection)
            collection_serializer.new(
              collection,
              collection_options(collection)
            ).serializable_hash
          end

          def collection_options(collection)
            {
              links: collection_links(collection),
              meta: collection_meta(collection),
              include: resource_includes,
              fields: sparse_fields
            }
          end

          def resource
            scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::WholesalerSerializer
          end

          def paginated_collection
            collection_paginator.new(collection, params).call
          end

          def collection
            Spree::Wholesaler.all
          end
  
          def collection_paginator
            Spree::Api::Dependencies.storefront_collection_paginator.constantize
          end

          def collection_serializer
            Spree::V2::Storefront::WholesalerSerializer
          end

          def scope
            Spree::Wholesaler.accessible_by(current_ability, :show).includes(scope_includes)
          end

          def current_ability
            @current_ability ||= Spree::WholesalerAbility.new(spree_current_user)
          end

          def scope_includes
            {
              user: {},
              business_address: {}
            }
          end
        end
      end
    end
  end
end