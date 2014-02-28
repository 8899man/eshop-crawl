class JdListCrawler < Crawler
  def initialize(args={})
    @format_url = 'http://list.jd.com/%s-0-0-0-0-0-0-0-1-1-%d-1-20-1720-22906-0.html'
    @category_ids = [
      '1320-9433-9435',
      '1320-9433-9437',
      '1320-9433-9438',
      '1320-9433-9439',
      '1320-9433-9436'
    ]
  end

  def get_all_list
    @category_ids.each do |category_id|
      get_list(category_id)
    end
  end

  def get_list(category_id)
    @page = get_page_total(category_id)
    (1..@page).each do |page|
      p 'get ' +category_id + ' | page: ' + page.to_s
      get_page(category_id, page)
    end
  end

  def get_page_total(category_id)
    url = @format_url % [category_id, 1]
    page = Nokogiri::HTML(open(url))
    total = page.css('.total strong').text
    total.to_i / 36 + 1 unless total.blank?
  end

  def get_page(category_id, page)
    url = @format_url % [category_id, page]
    page = Nokogiri::HTML(open(url))
    urls = page.css('#plist .p-name a').map{|link| Hash[:url, link.attr('href')]}
    WineLink.create urls
  end

end
