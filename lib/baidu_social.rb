class BaiduSocial
  include HTTParty
  base_uri 'https://openapi.baidu.com/social/api/2.0'

  def info(access_token)
    options = {query: {access_token: access_token}}
    self.class.get('/user/info',options).to_hash
  end

  def share(access_token, content, url, pic_url=nil)
    options = {body: {access_token: access_token, content: content, url: url, pic_url: pic_url}}
    self.class.post('/share',options).to_hash
  end

  def share_batch(access_tokens, content, url, pic_url=nil)
    options = {body: {access_tokens: access_tokens.join(','), content: content, url: url, pic_url: pic_url}}
    self.class.post('/share_batch',options).to_hash
  end

  #no care about
  def bind(access_token, uid, uname=nil)
    options = {body: {access_token: access_token, uid: uid, uname: uname}}
    self.class.post('/user/bind',options).to_hash
  end

  def unbind(access_token)
    options = {body: {access_token: access_token}}
    self.class.post('/user/unbind',options).to_hash
  end

  def bind_status(access_token,uid = nil)
    options = {query: {access_token: access_token, uid: uid}}
    self.class.get('/user/bind_status',options).to_hash
  end
end
