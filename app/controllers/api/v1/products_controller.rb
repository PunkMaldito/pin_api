module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [ :show, :update, :destroy, :sell, :build ]

      def index
        products = Product.all
        pagy, paginated_products = pagy(products, items: per_page)

        render json: ProductSerializer.new(paginated_products).serializable_hash.merge(
          meta: pagination_meta(pagy)
        )
      end

      def show
        render json: {
          data: ProductSerializer.new(@product).serializable_hash
        }
      end

      def create
        authorize Product
        product = Product.new(product_params)

        if product.save
          render json: {
            data: ProductSerializer.new(product).serializable_hash
          }, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @product
        if @product.update(product_params)
          render json: {
            data: ProductSerializer.new(@product).serializable_hash
          }
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @product
        @product.destroy!
        head :no_content
      end

      def sell
        authorize @product, :sell?
        quantity = params[:quantity].to_i

        result = ProductOperations::SellService.call(@product, quantity)

        if result.success?
          render json: {
            data: ProductSerializer.new(result.data).serializable_hash[:data],
            message: "Sold #{quantity} units successfully"
          }
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      def build
        authorize @product, :build?
        quantity = params[:quantity].to_i

        result = ProductOperations::BuildService.call(@product, quantity)

        if result.success?
          render json: {
            data: ProductSerializer.new(result.data).serializable_hash[:data],
            message: "Built #{quantity} units successfully"
          }
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :stock, :price)
      end

      def per_page
        [ (params[:per_page] || 10).to_i, 100 ].min
      end

      def pagination_meta(pagy)
        {
          current_page: pagy.page,
          total_pages: pagy.pages,
          total_count: pagy.count,
          per_page: pagy.vars[:items],  # Fixed: use vars[:items] instead of items
          next_page: pagy.next,
          prev_page: pagy.prev
        }.compact
      end
    end
  end
end
