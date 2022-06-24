class UserAlsoViewed
  def initialize(item_id)
    @item_id = item_id
  end

  def score(item_id)
    REDIS.with do |conn|
      conn.zscore(redis_zset_key, item_id) || 0
    end
  end

  def items_by_score_desc
    REDIS.with do |conn|
      conn.call(:zrevrangebyscore, redis_zset_key, "INF", "-INF")
    end
  end

  def add_or_update_item(item_id, score)
    return false if item_id == @item_id
    REDIS.with do |conn|
      conn.zincrby(redis_zset_key, score, item_id)
    end
  end

  class << self
    def [](item_id)
      UserAlsoViewed.new(item_id)
    end
  end

  def redis_zset_key
    # uav stands for user also viewed
    "uav:#{@item_id}"
  end
end