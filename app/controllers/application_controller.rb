class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :decrypt_userid, :except => :login
  def decrypt_userid
  	begin
	  	user = params[:user] || "Pna5QTNNDcAqdy8A6HISfQ==%0A"
	    @user_id = decrypt(user)
	rescue
		@user_id = 122608475
	end
  end

  def decrypt(enced)
  	secret_key = Digest::SHA256.hexdigest('MAPLEINYOURFACE')
  	enced_1 = Base64.decode64(enced)
  	decrypted_value = Encryptor.decrypt(:value => enced_1, :key => secret_key, :algorithm => "bf")
  end

  def encrypt(toenc)
  	secret_key = Digest::SHA256.hexdigest('MAPLEINYOURFACE')
    enced = Encryptor.encrypt(toenc, :key => secret_key, :algorithm => "bf")
    enced_1 = Base64.encode64(enced)
    enced_2 = URI.encode(enced_1)
  end
end
