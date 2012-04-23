class PictureFetcher
	def initialize(user_id)
    	@user_id = user_id
  	end

	def self.fetch(user_id)
		Delayed::Job.enqueue(PictureFetcher.new(user_id), 0)
	end

	def perform
		interests = REDIS.smembers("interests:#{user_id}")
	end

	def fetch_and_store_pictures(user_id, token)
		key = "picture_timesort:#{user_id}"

		# REDIS.zcount("picture_timesort:1229271","-inf","inf")
		# REDIS.zrange("picture_timesort:1229271", 0,5,{withscores: true})

		if REDIS.llen(key) != 0
			puts "ENTRIES ALREADY PRESENT FOR USER - NOT RE-STORING ANY PICS"
			return
		end
		url = "https://graph.facebook.com/#{user_id}/photos?access_token=#{token}"
		body = get_page(url)
		list = JSON.parse(body)
		while true
			REDIS.pipelined {
				puts "STORING - #{list['data'].size}"
				list['data'].each do |l|
		        	REDIS.rpush key, l.to_json
		        end
	    	}
	 		url = list['paging']['next'] rescue nil
	 		if url == nil
	 			break
	 		else
	 			body = get_page(url)
	 			list = JSON.parse(body)
	 		end
		end
	end

end