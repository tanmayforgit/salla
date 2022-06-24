class UserVisitedItems
  class << self
    def add(user_id, item_id)
      REDIS.with do |conn|
        conn.sadd(redis_set_key(user_id), item_id)
      end
    end

    def [](user_id)
      REDIS.with do |conn|
        conn.smembers(redis_set_key(user_id))
      end
    end

    private

    def redis_set_key(user_id)
      "user_items:#{user_id}"
    end
  end
end