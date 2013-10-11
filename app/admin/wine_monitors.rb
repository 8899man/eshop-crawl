ActiveAdmin.register WineMonitor do
  form do |f|
    f.inputs do
      #f.input :lib, collection: YAML.load(ENV['CRAWLS']), include_blank: nil
      f.input :sn
      f.input :norm
      f.input :wines, collection: Wine.all, include_blank: nil
      f.input :website, collection: Website.all, include_blank: nil
    end
    f.actions
  end

end
