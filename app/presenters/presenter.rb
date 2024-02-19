#
# Generic presenter base class which delegates (via the Ruby's standard library
# SimpleDelegator class and its method_missing implementation) any unknown method
# calls to the view with which the Presenter is initialized (e.g. the controller's
# view_context).
# See {http://www.saturnflyer.com/blog/jim/2013/03/21/ruby-delegate-rb-secrets/ here}.
# This means that any Presenter subclass can for example use content_tag or link_to
# and these will be intercepted and handled by this Presenter base class.
# for more info
#
# @example
#
#   # app/presenters/thing_presenter.rb
#
#   class ThingPresenter < Presenter
#
#     delegate :name, to: :thing
#
#     def initialize(thing, view_context)
#       @thing = thing
#       super(view_context)
#     end
#
#     def age
#       "about #{thing.age}"
#     end
#
#     private
#
#     attr_reader :thing
#
#   end
#
#   # app/controllers/thing_controller.rb
#
#   class ThingController < ApplicationController
#     respond_to :html
#
#     def show
#       thing = Thing.find(params[:id])
#       @presenter = ThingPresenter.new(thing, view_context)
#       respond_with @presenter
#     end
#
#   end
#
#   # app/views/thing.html.erb
#
#   <p><%=@presenter.name %> is <%=@presenter.age %></p>
#
class Presenter < SimpleDelegator
  attr_reader :view_context

  # Make our route helpers (*_path etc) available
  include Rails.application.routes.url_helpers

  # Save away the view but also call super (SimpleDelegator) which will make sure
  # that any calls in any subclass, like content_tag, will be forwarded onto the view_context
  # automatically via SimpleDelegator method_missing implementation.
  def initialize(view_context)
    @view_context = view_context
    super
  end

  def default_url_options
    Rails.application.routes.default_url_options
  end

  def blank_value
    content_tag :em, I18n.t("presenters.blank"), class: "text-muted"
  end

  def nil_value
    content_tag :em, I18n.t("presenters.nil"), class: "text-muted"
  end

  def friendly_date(date)
    formatted_date = date && I18n.l(date.to_date, format: :long)
    formatted_date || ""
  end

  def friendly_expiry_date(date)
    return I18n.t("presenters.no_expiry_date_present") unless date

    I18n.l(date.to_date, format: :long)
  end

  # Add any common methods like app-specific date formatters etc here
end
