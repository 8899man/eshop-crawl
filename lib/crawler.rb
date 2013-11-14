class Crawler
  def initialize(args)
    raise ' '
  end

  def get(wine_monitor)
    raise ' '
  end

  def get_norm(text)
    match_norm = @regx_norm.match(text)
    if match_norm
      norm = match_norm[:norm]
      norm = norm.to_f * 1000 if !match_norm[:ml] and match_norm[:l]
    else
      norm = nil
    end
    norm
  end
end
