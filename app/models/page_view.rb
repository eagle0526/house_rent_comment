class PageView < Impression

    # PageView.group(:impressionable_type).count  => {"House"=>34}                  , 這個可以紀錄目前所有類型的瀏覽次數，並且用hash表示
    # PageView.group(:impressionable_id).count  => {11=>2, 0=>22, 83=>1, 12=>9}     , 這個可以根據impressionable_id，紀錄次數，並且用hash表示
    #                                                                                 不過 0 和 83 還不知道是啥，為啥也會吃到impression
    # PageView.group(:created_at).count
    # {Wed, 19 Apr 2023 06:13:15.328970000 UTC +00:00=>1,                                    
    #  Wed, 19 Apr 2023 05:13:37.823239000 UTC +00:00=>1}                           , 可以把所有count的計算時間列出來 
    
    # PageView.group('date(created_at)').count   => {Wed, 19 Apr 2023=>35}          , 把create時間全部轉成日期
  
  
    # PageView.select(:ip_address)          -> 列出一大串ip陣列
    # PageView.select(:ip_address).distinct -> 刪除重複陣列
    # PageView.select(:ip_address).distinct.group('date(created_at)').count  =>  {Wed, 19 Apr 2023=>1} , 把 ip 那一串，轉成hash
    
    
    # TODO:
    # 0.自定義一段時間的瀏覽量          -> for_date_range
    # 1.定義過去7天的瀏覽量             -> count_by_date
    # 2.定義過去7天不重複的瀏覽量(uniq)  -> uniq_count_by_date
    # 3.定義照瀏覽次數排序的scope
    # 4.定義照不重複瀏覽次數排序的scope
  
  
  
  
  
  
    # PageView.for_type("House")  -> 這樣輸入，可以得到所有類型為"House"的impression資料
    scope :for_type, -> (type) do 
      Impression.where(impressionable_type: type)
    end
  
    # PageView.for_date_range(7.days.ago, Date.today)  -> 這樣輸入，可以列出近7天的所有瀏覽資料
    scope :for_date_range, -> (start_date, end_date) do
      where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end
  
    # PageView.for_date_range(7.days.ago, Date.today).count_by_date  -> 這樣會把上面 for_date_range 的一堆時間，經由date(created_at)和group整理成一包Hash
    #  -> {Wed, 19 Apr 2023=>35}
  
    # PageView.for_date_range(1.days.ago, Date.today).count_by_date -> 抓一天前的瀏覽次數 
    scope :count_by_date, ->() do
      group('date(created_at)').count
    end
  
    # PageView.uniq_count_by_date => {Wed, 19 Apr 2023=>1}
    scope :uniq_count_by_date, -> () do
      select(:ip_address).distinct.group('date(created_at)').count
    end
  
  
    # 因為之後可能不止一個物件會用到計算瀏覽次數的功能，因此多寫一個model，來特別寫計算瀏覽數的方法
  end