ActiveAdmin.register WineMonitor do
  scope :recent, :default => true
  scope :running
  scope :cheapest

  filter :name
  filter :en_name
  filter :current_price
  filter :norm

  index do
    selectable_column
    column :lib, :sortable => true do |monitor|
      link_to monitor.lib, admin_wine_monitor_path(monitor)
    end

    column :sn

    column :name, :sortable => true do |monitor|
      link_to monitor.name, admin_wine_monitor_path(monitor)
    end

    column :en_name do |monitor|
      link_to monitor.en_name || '', admin_wine_monitor_path(monitor)
    end

    column :current_price , sortable: :current_price do |monitor|
      number_to_currency monitor.current_price
    end

    column :norm
    column :price_per_liter
    column :min_price_per_liter
    column :created_at
    #actions
  end

  form do |f|
    f.inputs do
      #f.input :lib, collection: YAML.load(ENV['CRAWLS']), include_blank: nil
      f.input :name, html: {disabled: true}
      f.input :sn
      f.input :norm
      f.input :wines, collection: Wine.all
      f.input :website, collection: Website.all, include_blank: nil
    end
    f.actions
  end

end
