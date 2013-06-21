# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  navigation.active_leaf_class = ''

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #
    if current_gym && current_gym.try(:confirmed)
      primary.item :orders, t('nav.orders'), admin_orders_url
      primary.item :venues, t('nav.venues'), admin_venues_url
      primary.item :activities, t('nav.activities'), admin_activities_url
      primary.item :products, t('nav.products'), admin_products_url
      primary.item :cards, t('nav.cards'), admin_cards_url
    end
    primary.item :users, t('nav.users'), admin_users_url if can? :manage, User

    if can?(:manage, Company) || can?(:manage, GymGroup) || can?(:manage, VenueType) || can?(:manage, City) || can?(:manage, Area) || can?(:manage, PaymentMethod) || can?(:manage, UserAgreement)
      primary.item :settings, t('nav.settings'), '#' do |sub_nav|
        sub_nav.item :companies, t('nav.companies'), admin_companies_url if can?(:manage, Company)

        if can?(:manage, GymGroup) && current_company
          sub_nav.item :gym_groups, t('nav.settings_nav.gym_groups'), admin_gym_groups_url if can?(:manage, GymGroup)
        end

        primary.item :gyms, t('nav.gyms'), admin_gyms_url if can?(:read, Gym)

        if current_company
          if can?(:manage, CardType)
            sub_nav.item :card_types, t('nav.card_types'), admin_card_types_url
          end
          if can?(:manage, CardCharge)
            sub_nav.item :card_charges, t('nav.card_charges'), admin_card_charges_url
          end
        end

        if can?(:manage, VenueType)
          sub_nav.item :venue_types, t('nav.settings_nav.venue_types'), admin_venue_types_url
        end
        if can?(:manage, City)
          sub_nav.item :cities, t('nav.settings_nav.cities'), admin_cities_url
        end
        if can?(:manage, Area)
          sub_nav.item :areas, t('nav.settings_nav.areas'), admin_areas_url
        end
        if can?(:manage, PaymentMethod)
          sub_nav.item :payment_methods, t('nav.settings_nav.payment_methods'), admin_payment_methods_url
        end
        sub_nav.item :user_agreements, t('nav.user_agreements'), admin_user_agreements_url if can?(:manage, UserAgreement)
        sub_nav.item :contacts, t('contact_us'), admin_contacts_url if can?(:manage, Contact)
      end
    end
    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'nav'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
