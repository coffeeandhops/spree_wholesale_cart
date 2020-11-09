module Spree
  module Api
    module V2
      module Storefront
        class WholesaleCartController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers
          include Spree::Api::V2::Storefront::OrderConcern
          before_action :ensure_order, except: :create
          before_action :require_spree_current_user

          def show
            spree_authorize! :show, spree_current_order, order_token

            render_serialized_payload { serialize_resource(resource) }
          end

          def add_item
            variant = Spree::Variant.find(params[:variant_id])

            spree_authorize! :update, spree_current_order, order_token
            spree_authorize! :show, variant

            result = add_item_service.call(
              wholesale_order: spree_current_wholesale_order,
              variant: variant,
              quantity: params[:quantity]
            )

            render_wholesale_order(result)            
          end

          def empty
          end

          def remove_line_item
          end

          def set_quantity
          end

          private

          # THIS HAS BEEN MOVED TO BASE CONTROLLER
          def serialize_resource(resource)
            resource_serializer.new(
              resource,
              include: resource_includes,
              fields: sparse_fields
            ).serializable_hash
          end

          def resource
            spree_current_order.wholesale_order
          end

          def resource_serializer
            Spree::V2::Storefront::WholesaleCartSerializer
          end

          def scope
            Spree::WholesaleOrder.accessible_by(current_ability, :show).includes(scope_includes)
          end

          # def current_ability
          #   @current_ability ||= Spree::WholesalerAbility.new(spree_current_user, spree_current_order)
          # end

          def add_item_service
            Spree::WholesaleCart::AddItem.new
          end

          def render_wholesale_order(result)
            if result.success?
              render_serialized_payload { serialized_current_wholesale_order }
            else
              render_error_payload(result.error)
            end
          end

          def serialize_wholesale_order(order)
            resource_serializer.new(spree_current_wholesale_order.reload, include: resource_includes, fields: sparse_fields).serializable_hash
          end

          def serialized_current_wholesale_order
            serialize_wholesale_order(spree_current_order.wholesale_order)
          end

          def spree_current_wholesale_order
            @spree_current_wholesale_order ||= spree_current_order.wholesale_order
          end

          # def scope_includes
          #   {
          #     user: {}
          #   }
          # end

        end
      end
    end
  end
end