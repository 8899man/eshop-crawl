# coding: utf-8
class JdUser
  def level(level)
    levels[l]
  end

  def self.levels
    if @levels.blank?
      @levels  = Hash.new
      @levels[50] = "注册用户"
      @levels[56] = "铜牌用户"
      @levels[59] = "注册用户"
      @levels[60] = "银牌用户"
      @levels[61] = "银牌用户"
      @levels[62] = "金牌用户"
      @levels[63] = "钻石用户"
      @levels[64] = "经销商"
      @levels[110] = "VIP"
      @levels[66] = "京东员工"
      @levels[-1] = "未注册"
      @levels[88] = "钻石用户"
      @levels[90] = "企业用户"
      @levels[103] = "钻石用户"
      @levels[104] = "钻石用户"
      @levels[105] = "钻石用户"
    end
    return @levels
  end
end
