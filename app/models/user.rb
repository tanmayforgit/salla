class User
  def initialize(user_id)
    @user_id = user_id
  end

  def recently_visited_items
    recently_visited_time_as_int = (Time.now - DURATION_FOR_RECENT_VISIT).to_i
    REDIS.with do |conn|
      conn.zrangebyscore(redis_zset_key, recently_visited_time_as_int, Time.now.to_i) || []
    end
  end

  def visit(item_id)
    score = Time.now.to_i
    REDIS.with do |conn|
      conn.zadd(redis_zset_key, score, item_id)
    end
  end

  class << self
    def [](user_id)
      new(user_id)
    end
  end

  private

  def redis_zset_key
    # UI stands for useritems
    "ui:#{@user_id}"
  end
end