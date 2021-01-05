module Spree
  module Api
    module V2
      module Storefront
        class WholesaleCartController < ::Spree::Api::V2::BaseController
          include Spree::Api::V2::CollectionOptionsHelpers
          include Spree::Api::V2::Storefront::OrderConcern
          before_action :ensure_order
          before_action :ensure_wholesale_order, except: :create
          before_action :require_spree_current_user

          def create
            spree_authorize! :create, Spree::WholesaleOrder

            wholesale_order   = spree_current_wholesale_order if spree_current_wholesale_order.present?
            wholesale_order ||= create_service.call(order: spree_current_order).value

            render_serialized_payload(201) { serialize_order(wholesale_order) }
          end

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
            spree_authorize! :update, spree_current_order, order_token

            result = empty_service.call(wholesale_order: spree_current_wholesale_order)
            render_wholesale_order(result)
          end

          def remove_line_item
            spree_authorize! :update, spree_current_order, order_token

            result = remove_line_item_service.call(
              wholesale_order: spree_current_wholesale_order,
              line_item: wholesale_line_item
            )
            
            render_wholesale_order(result)
          end

          def set_quantity
            spree_authorize! :update, spree_current_order, order_token

            line_item = Spree::WholesaleLineItem.find(params[:wholesale_line_item_id])

            result = set_quantity_service.call(
              wholesale_order: spree_current_wholesale_order,
              line_item: line_item,
              quantity: params[:quantity].to_i)

            render_wholesale_order(result)
          end

          def add_to_order
            spree_authorize! :update, spree_current_order, order_token
            spree_authorize! :create, Spree::WholesaleOrder

            result = add_to_order_service.call(wholesale_order: spree_current_wholesale_order)
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp result
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            render_wholesale_order(result)
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

          def create_service
            Spree::WholesaleCart::Create.new
          end

          def add_item_service
            Spree::WholesaleCart::AddItem.new
          end

          def remove_line_item_service
            Spree::WholesaleCart::RemoveLineItem.new
          end

          def empty_service
            Spree::WholesaleCart::Empty.new
          end

          def set_quantity_service
            Spree::WholesaleCart::SetQuantity.new
          end
          
          def add_to_order_service
            Spree::WholesaleCart::AddToOrder.new
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

          def ensure_wholesale_order
            raise ActiveRecord::RecordNotFound if spree_current_wholesale_order.nil?
          end

          def wholesale_line_item
            @wholesale_line_item ||= spree_current_wholesale_order.wholesale_line_items.find(params[:wholesale_line_item_id])
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