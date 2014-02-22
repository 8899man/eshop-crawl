# coding utf-8
class WineFilterController
  def initialize(args={})
    @wine_filter = WineFilter.new
  end

  def refilter_all
    refilter_countries
    refilter_brands
  end

  def refilter_countries
    @countries_keys_regexp ||= @wine_filter.countries_keys_regexp
    WineMonitor.where(:name => @countries_keys_regexp).each do |wine_monitor|
      refilter_country wine_monitor
    end
  end

  def refilter_country wine_monitor
    wine_monitor.country_list = @wine_filter.countries[@countries_keys_regexp.match(wine_monitor.name)[0]]
    wine_monitor.save if wine_monitor.country_list_changed?
  end

  def refilter_brands
    @brands_keys_regexp ||= @wine_filter.brands_keys_regexp
    WineMonitor.where(:name => @brands_keys_regexp).each do |wine_monitor|
      refilter_brand wine_monitor
    end
  end

  def refilter_brand wine_monitor
    wine_monitor.brand_list = @wine_filter.brands[@brands_keys_regexp.match(wine_monitor.name)[0]]
    wine_monitor.save if wine_monitor.brand_list_changed?
  end
end
