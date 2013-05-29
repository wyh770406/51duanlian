module Admin
  class VenueInventoriesController < Admin::BaseController
    def edit_individual
      @venue_inventories = current_gym.venue_inventories.includes(:venue_type)
    end

    def update_individual
      params[:venue_inventories].delete_if { |id, p| !(current_gym.venue_inventory_ids.include?(id.to_i)) }

      @venue_inventories = VenueInventory.update(params[:venue_inventories].keys, params[:venue_inventories].values)
      if @venue_inventories.reject { |vi| vi.errors.empty? }.blank?
        redirect_to edit_individual_admin_venue_inventories_path, notice: t("flash.update.success")
      else
        flash[:alert] = t("flash.update.failure")
        render 'edit_individual'
      end
    end
  end
end
