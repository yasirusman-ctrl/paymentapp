module Admin
  class PlansController < ApplicationController
    before_action :set_plan, only: [:show, :edit, :update, :destroy]

    def index
      authorize Plan
      @plans = Plan.all
    end

    def show
      authorize @plan
    end

    def new
      @plan = Plan.new
      authorize @plan
    end

    def create
      @plan = Plan.new(plan_params)
      authorize @plan

      if @plan.save
        redirect_to admin_plans_path, notice: "Plan created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @plan
    end

    def update
      authorize @plan
      if @plan.update(plan_params)
        redirect_to admin_plans_path, notice: "Plan updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @plan
      @plan.destroy
      redirect_to admin_plans_path, notice: "Plan deleted successfully."
    end

    private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:name, :monthly_fee, feature_ids: [])
    end
  end
end
