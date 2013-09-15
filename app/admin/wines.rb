ActiveAdmin.register Wine do
   form do |f|
    f.inputs do
      f.input :name
      f.input :introduction
      f.input :description
      f.input :min_price
      f.input :current_price
      f.input :min_starting_price
      f.input :max_starting_price
      f.input :categories
    end
    f.actions
  end
 
end
