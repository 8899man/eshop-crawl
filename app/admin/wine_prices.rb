ActiveAdmin.register WinePrice do
  form do |f|
    f.inputs do
      f.input :url
      f.input :current_price
      f.input :tag_price
      f.input :started_at, :as => :string, :input_html => {:class => "hasDatetimePicker", :value => Time.now}
      f.input :finished_at, :as => :string, :input_html => {:class => "hasDatetimePicker", :value => nil}

      f.input :wine, collection: Wine.all
      f.input :website, collection: Website.all
      f.input :event_type_list
    end
    f.actions
  end
end
