class User
  include Mongoid::Document
  rolify
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :authentication_keys => [:login], :omniauth_providers => [:baidu]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  index({ email: 1 }, { unique: true, background: true })
  field :name, :type => String
  validates_presence_of :name
  field :phone, :type => String
  validates :name, presence: true, length: 2..10, uniqueness: true
  validates :phone, format: {with: /1[3458](\d{9})/}, uniqueness: true, if: :phone?#, presence: true
  attr_accessor :login, :omniauth_session
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at, :login, :phone

  has_many :authentications

  def to_s
    self.name.to_s
  end

  def self.find_for_database_authentication(conditions={})
    self.where(email: conditions[:login]).limit(1).first ||
      self.where(phone: conditions[:login]).limit(1).first ||
      self.where(name: conditions[:login]).limit(1).first
  end

  def password_required?
    super
  end

  def apply_omniauth(omniauth)
    authentications.build(
      provider: omniauth.provider, 
      uid: omniauth.uid,
      access_token: omniauth.credentials.token)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (omniauth = session['omniauth']) and session['omniauth'].info
        user.omniauth_session = session
        user.name = omniauth.info.name if params[:name].blank?
      end
    end
  end

  def add_authentication
    if omniauth_session and (omniauth = omniauth_session['omniauth'])
      authentications.create(
        provider: omniauth.info.media_type,
        uid: omniauth.info.media_uid,
        uname: omniauth.info.name,
        access_token: omniauth.credentials.token
      )
      omniauth_session.delete :omniauth
    end
  end
end
