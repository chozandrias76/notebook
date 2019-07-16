class GraphicsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_sidenav_expansion
  before_action :set_navbar_color
  before_action :set_navbar_actions, except: [:edit]
  before_action :set_footer_visibility, only: [:edit]

  def index
    @graphics = current_user.graphics.order('updated_at desc')
  end

  def show
    @graphic = Graphic.find_by(id: params[:id], user_id: current_user.id)

    unless @graphic.present? || @graphic.viewable_by?(current_user || User.new)
      redirect_to(root_path, notice: "That graphic either doesn't exist or you don't have permission to view it.")
    end

    @navbar_actions.unshift({
      label: (@graphic.name || 'Untitled graphic'),
      href: graphic_path(@graphic)
    })
  end

  def edit
    @graphic = Graphic.find_by(id: params[:id], user_id: current_user.id)
    @graphic ||= current_user.graphics.create

    # This eases graphics from the old editor into the new one, replacing \n with <br>s
    # Todo this line can be removed after running a migration that updates all existing graphics, since you can no longer create a graphic with raw newlines
    @graphic.update(body: @graphic.body.gsub("\n", "<br />")) if @graphic.body.present? && @graphic.body.include?("\n")

    redirect_to root_path unless @graphic.updatable_by?(current_user)
  end

  def create
    created_graphic = current_user.graphics.create(graphic_params)
    redirect_to edit_graphic_path(created_graphic), notice: "Your graphic has been saved!"
  end

  def update
    graphic = Graphic.with_deleted.find_or_initialize_by(id: params[:id], user: current_user)

    unless graphic.user == current_user
      redirect_to(dashboard_path, notice: "You don't have permission to do that!")
      return
    end

    if graphic.updatable_by?(current_user) && graphic.update(graphic_params)
      head 200, content_type: "text/html"
    else
      head 501, content_type: "text/html"
    end
  end

  def destroy
    graphic = Graphic.find_by(id: params[:id])

    if current_user.can_delete?(graphic)
      graphic.destroy
      redirect_to(graphics_path, notice: "The graphic was successfully deleted.")
    else
      redirect_to(root_path, notice: "You don't have permission to do that!")
    end
  end

  def set_sidenav_expansion
    @sidenav_expansion = 'writing'
  end

  def set_navbar_color
    content_type = content_type_from_controller(self.class)
    @navbar_color = content_type.hex_color
  end

  def set_navbar_actions
    @navbar_actions = []

    if @current_user_content['Graphic'].present?
      @navbar_actions << {
        label: "Your #{@current_user_content['Graphic'].count} Graphic#{'s' unless @navbar_actions == 1}",
        href: graphics_path
      }
    end

    @navbar_actions << {
      label: "New Graphic",
      href: edit_graphic_path(:new)
    }
  end

  def set_footer_visibility
    @show_footer = false
  end

  private

  def graphic_params
    params.require(:graphic).permit(:title, :body, :deleted_at)
  end
end
