# coding utf-8
class WineFilterController
  def initialize(args={})
    @wine_filter = WineFilter.new
    @children_types = @wine_filter.children_types
    @brands = @wine_filter.brands
    @countries = @wine_filter.countries
    @types = @wine_filter.types
    @types_keys_regexp = @wine_filter.types_keys_regexp
    @types_values_regexp = @wine_filter.types_values_regexp
    @countries_keys_regexp = @wine_filter.countries_keys_regexp
    @brands_keys_regexp = @wine_filter.brands_keys_regexp
  end

  def refilter_all
    #single
    refilter_countries
    refilter_brands

    #multi
    refilter_types
  end

  def refilter_wine_monitor wine_monitor
    refilter_country wine_monitor
    refilter_brand wine_monitor
    refilter_type wine_monitor
  end

  def refilter_countries
    WineMonitor.where(:name => @countries_keys_regexp).each do |wine_monitor|
      refilter_country wine_monitor
    end
  end

  def refilter_country wine_monitor
    match = @countries_keys_regexp.match(wine_monitor.name)
    if match
      wine_monitor.country_list = @countries[match[0]]
      wine_monitor.save if wine_monitor.country_list_changed?
    end
  end

  def refilter_brands
    WineMonitor.where(:name => @brands_keys_regexp).each do |wine_monitor|
      refilter_brand wine_monitor
    end
  end

  def refilter_brand wine_monitor
    match = @brands_keys_regexp.match(wine_monitor.name)
    if match
      wine_monitor.brand_list = @brands[match[0]]
      wine_monitor.save if wine_monitor.brand_list_changed?
    end
  end

  #def refilter_main_types
    
  #end

  def filter_main_type wine_monitor
    types = []
    wine_monitor.types.select{|type| type.scan @types_values_regexp}.each do |key|
      types.push key
    end

    wine_monitor.main_type_list = @wine_filter.get_main_types_by_children_types(types).join(',')

    wine_monitor.save if wine_monitor.main_type_list_changed?
  end
    
  def refilter_types
    WineMonitor.where(:name => @types_keys_regexp).each do |wine_monitor|
      refilter_type wine_monitor
    end
  end

  def refilter_type wine_monitor
    if wine_monitor and !wine_monitor.name.blank?
      types = []
      wine_monitor.name.scan(@types_keys_regexp).each do |key|
        types.push @children_types[key]
      end

      wine_monitor.type_list = types.join(',')
      wine_monitor.save if wine_monitor.type_list_changed?
      filter_main_type(wine_monitor)
    end
  end
end
