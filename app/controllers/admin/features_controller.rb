module Admin
  class FeaturesController < ApplicationController
    before_action :set_feature, only: [:show, :edit, :update, :destroy]

    def index
      authorize Feature
      @features = Feature.all
    end

    def show
      authorize @feature
    end

    def new
      @feature = Feature.new
      authorize @feature
    end

    def create
      @feature = Feature.new(feature_params)
      authorize @feature

      if @feature.save
        redirect_to admin_features_path, notice: "Feature created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @feature
    end

    def update
      authorize @feature
      if @feature.update(feature_params)
        redirect_to admin_features_path, notice: "Feature updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @feature
      @feature.destroy
      redirect_to admin_features_path, notice: "Feature deleted successfully."
    end

    private

    def set_feature
      @feature = Feature.find(params[:id])
    end

    def feature_params
      params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
    end
  end
end
