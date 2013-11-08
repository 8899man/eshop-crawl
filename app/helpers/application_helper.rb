module ApplicationHelper
  def default_meta_tags
    {
      site: "#{t("controller.#{controller_name}")} | #{t('site_title')}",
      description: t('site_desc'),
      keywords: t('site_keywords'), 
      reverse: true,
    }
  end

  def d(model,attr, plus ='')
    if model.respond_to? attr and !model.send(attr).blank?
      tmp = content_tag(:dt,model.class.human_attribute_name(attr))
      tmp += content_tag(:dd,model.send(attr).to_s + plus)
    else
      ''
    end
  end

  def pb(model, attr, plus=nil)
    if model.respond_to? attr and !model.send(attr).blank?
      tmp = '<p>'
      tmp += content_tag(:b,model.class.human_attribute_name(attr))
      tmp += '：'
      tmp += model.send(attr).to_s
      tmp += ' ' + plus if plus
      tmp += '</p>'
      tmp.html_safe
    else
      ''
    end
  end


  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def upload_image_tag image,name,size=nil
    raw image_tag image.url(size),alt:name,title:name
  end

end
