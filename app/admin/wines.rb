ActiveAdmin.register Wine do
  form do |f|
    f.inputs do
      f.input :name
      f.input :introduction
      f.input :description
      f.input :min_price
      f.input :current_price
      f.input :fit_price
      f.input :categories
      f.input :image
    end
    #f.inputs do
    #f.has_many :wine_monitors do |wine_monitor|
    #wine_monitor.input :lib, collection: YAML.load(ENV['CRAWLS']), include_blank: nil
    #wine_monitor.input :sn
    #wine_monitor.input :website, collection: Website.all, include_blank: nil
    #end
    #end
    f.actions
  end


  show title: :name do |wine|
    attributes_table do
      #row :name
      row :current_price
      row :min_price
      row :fit_price
      row :image do
        image_tag(wine.image.url)
      end
      row :introduction
      row :description
    end
  end
end
