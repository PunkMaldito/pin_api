module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [ :show, :update, :destroy, :sell, :build ]

      def index
        products = Product.all

        render json: ProductSerializer.new(products).serializable_hash
      end

      def show
        render json: ProductSerializer.new(@product).serializable_hash
      end

      def created
        product = Product.new(product_params)

        authorize product

        if product.save
          render json: ProductSerializer.new(product).serializable_hash, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @product

        if @product.update(product_params)

          render json: ProductSerializer.new(@product).serializable_hash
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
        authorize @product

        result = ProductOperations::SellService.call(@product, params[:quantity])

        if result.success?
          render json: ProductSerializer.new(result.product).serializable_hash
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      def build
        authorize @product

        result = ProductOperations::BuildService.call(@product, params[:quantity])

        if result.success?
          render json: ProductSerializer.new(result.product).serializable_hash
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
    end
  end
end
