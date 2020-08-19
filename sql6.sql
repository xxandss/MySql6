/*查询数据库中的数据，统计以下信息：
为需要查询的数据创建对应的数据库索引
编写SQL回答如下问题：
1 一共有多少不同的用户
2 一共有多少不同的电影
3 一共有多少不同的电影种类
4 一共有多少电影没有外部链接
5 2018年一共有多少人进行过电影评分
6 2018年评分5分以上的电影及其对应的标签
162541，62423，20，107，11999*/
#1 
   select  COUNT(distinct a.userId)
     from ((select distinct userId
               from tags)
	         UNION
	         (select distinct userId
	            from ratings)) as a    ;
#2
   select count(distinct movieId)  
     from movies     ;

#3
   select  count(distinct b.genr)
     from  (select  substring_index(genres, '|', 1)  as genr
              from  movies) as b     ;

#4   
    select
    (select count(distinct movieId)
     from movies)
		-
		(select count(*)
		  from links
		 where tmdbId is not null)  as c   ;
	
#5	
    select count(distinct d.userId)
      from (select userId , FROM_UNIXTIME(timestamp,'%Y-%m-%d %H:%i:%s') as date
              from ratings ) as d
     where d.date>='2018-01-01 00:00:00' and d.date<'2019-01-01 00:00:00'    ;
 
#6
	  select t2.movieId ,t3.tags
	    from (select movieId, avg(rating) as score
	           from (select *, FROM_UNIXTIME(timestamp,'%Y-%m-%d %H:%i:%s') as date
                     from  ratings ) as t1
	          where t1.date>='2018-01-01 00:00:00' and t1.date<'2019-01-01 00:00:00' 
            group by movieId )  as t2
	    left join (select movieId,group_concat(tag) as tags
	                   from tags 
	                  group by movieId ) as t3
	      on t2.movieId = t3.movieId  
	   where t2.score>=5   ;
	 
	 

	