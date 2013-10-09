class LayoutsCell < Cell::Rails
  cache :footer, :expires_in => 1.day

  cache [:trader_nav, :admin_nav, :user_nav] do |cell, options|
    "#{cell}_#{options[:controller_name]}##{options[action_name]}"
  end

  def footer
    render
  end

  def trader_nav(args)
    nav(args)
  end

  def admin_nav(args)
    nav(args)
  end

  def user_nav(args)
    nav(args)
  end

  def login(args)
    @user = args[:user]
    render
  end

  protected
  def nav(args)
    @controller_name = args[:controller_name]
    @action_name = args[:action_name]
    render
  end
end
