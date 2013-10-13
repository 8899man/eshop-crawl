DateTime::DATE_FORMATS[:default]="%Y-%m-%d %H:%M:%S"

Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"

Date::DATE_FORMATS[:default] = "%Y-%m-%d"

class String
  def block len=80,str = '...'
    if self.length > len
      return self[0,len] + str
    end
    self
  end
end

class Time
  def self.cc_time(tar)
    t,bt = tar,(Time.now-tar).to_i
    ys = t-Time.now.beginning_of_year
    case bt
    when 0..60
      "刚刚"
    when 60..3600
      "#{bt / 60} 分钟前"
    when 3600..3600*24
      "#{ bt / 3600} 小时前"
    when 3600*24..3600*24*2
      "昨日 #{t.strftime('%H:%M')}"
    when 3600*24*2..3600*24*7
      "#{bt / 86400} 天前"
    when 3600*24*7..ys
      t.strftime('%m-%d')
    else
      t.strftime('%Y-%m-%d')
    end
  end

  def cc_time
    tar = self
    t,bt = tar,(Time.now-tar).to_i
    ys = t-Time.now.beginning_of_year
    case bt
    when 0..3600
      "#{bt / 60} 分钟前"
    when 3600..3600*24
      "#{ bt / 3600} 小时前"
    when 3600*24..3600*24*2
      "昨日 #{t.strftime('%H:%M')}"
    when 3600*24*2..3600*24*7
      "#{bt / 86400} 天前"
    when 3600*24*7..ys
      t.strftime('%m-%d')
    else
      t.strftime('%Y-%m-%d')
    end
  end
end
