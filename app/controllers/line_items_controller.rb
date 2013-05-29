class LineItemsController < BaseController
  respond_to :js
  before_filter :load_order

  def update
    @line_item = @order.line_items.find(params[:id])
    @line_item.update_attributes(params[:line_item])
  end

  def destroy
    @line_item = @order.line_items.find(params[:id])
    @line_item.destroy
  end

  protected

  def load_order
    @order = current_order
  end
end
