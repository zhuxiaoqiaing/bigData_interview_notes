一. SCHEMAL
--建表
--学生表
CREATE TABLE `Student`(
    `s_id` VARCHAR(20),
    `s_name` VARCHAR(20) NOT NULL DEFAULT '',
    `s_birth` VARCHAR(20) NOT NULL DEFAULT '',
    `s_sex` VARCHAR(10) NOT NULL DEFAULT '',
    PRIMARY KEY(`s_id`)
);
--课程表
CREATE TABLE `Course`(
    `c_id`  VARCHAR(20),
    `c_name` VARCHAR(20) NOT NULL DEFAULT '',
    `t_id` VARCHAR(20) NOT NULL,
    PRIMARY KEY(`c_id`)
);
--教师表
CREATE TABLE `Teacher`(
    `t_id` VARCHAR(20),
    `t_name` VARCHAR(20) NOT NULL DEFAULT '',
    PRIMARY KEY(`t_id`)
);
--成绩表
CREATE TABLE `Score`(
    `s_id` VARCHAR(20),
    `c_id`  VARCHAR(20),
    `s_score` INT(3),
    PRIMARY KEY(`s_id`,`c_id`)
);
--插入学生表测试数据
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('08' , '王菊' , '1990-01-20' , '女');
--课程表测试数据
insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');

--教师表测试数据
insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');

--成绩表测试数据
insert into Score values('01' , '01' , 80);
insert into Score values('01' , '02' , 90);
insert into Score values('01' , '03' , 99);
insert into Score values('02' , '01' , 70);
insert into Score values('02' , '02' , 60);
insert into Score values('02' , '03' , 80);
insert into Score values('03' , '01' , 80);
insert into Score values('03' , '02' , 80);
insert into Score values('03' , '03' , 80);
insert into Score values('04' , '01' , 50);
insert into Score values('04' , '02' , 30);
insert into Score values('04' , '03' , 20);
insert into Score values('05' , '01' , 76);
insert into Score values('05' , '02' , 87);
insert into Score values('06' , '01' , 31);
insert into Score values('06' , '03' , 34);
insert into Score values('07' , '02' , 89);
insert into Score values('07' , '03' , 98);

二.sqL practise

#1. 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
select s1.s_id from score s1 join score s2 on s1.s_id=s2.s_id and s1.c_id='01' and s2.c_id='02' where s1.s_score>s2.s_score;
#3. 查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.s_id,s.s_name,b.avg from (
	select s.s_id,avg(s_score) as avg from score s group by s.s_id having avg>=60
) b join student s on b.s_id=s.s_id;
#4.查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩和无成绩)
select s.s_id,s.s_name,b.avg from (    #有成绩的学生信息
	select s.s_id,avg(s_score) as avg from score s group by s.s_id having avg<=60
) b join student s on b.s_id=s.s_id
union all    #无成绩的学生信息
select s_id,s_name,0 from student
where s_id not in (select distinct s_id from score);
#5.查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select st.s_id,st.s_name,count(s.c_id) as '选课总数',sum(s.s_score) from student st left join score s on st.s_id=s.s_id group by s_id;
#6.查询"李"姓老师的数量 
select count(t_id) from teacher where t_name like '李%';
#7.查询学过"张三"老师授课的同学的信息
select s.* from student s join score sc on s.s_id=sc.s_id
join ( 
select c_id from course where t_id=(
select t_id from teacher where t_name='张三'
) ) c  on sc.c_id=c.c_id;   #使用三次join,这里可以用2次Join,在加上一次in语法
#8.查询没学过"张三"老师授课的同学的信息(无的情况比较难以判断,可以利用反面证明)
select * from 
    student c 
    where c.s_id not in(
        select a.s_id from student a join score b on a.s_id=b.s_id where b.c_id in(
            select c_id from course where t_id =(
                select t_id from teacher where t_name = '张三')));
#9.查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select s.* from student s join score s1 on s.s_id=s1.s_id and s1.c_id='01' join score s2 on s1.s_id=s2.s_id  and s2.c_id='02';

#10.查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select s.* from student s join score s1 on s.s_id=s1.s_id and s1.c_id='01' left join score s2 on s1.s_id=s2.s_id  and s2.c_id='02' where s2.c_id is null;

#等价写法
select a.* from 
    student a 
    where a.s_id in (select s_id from score where c_id='01' ) and a.s_id not in(select s_id from score where c_id='02');
#11.查询没有学全所有课程的同学的信息
select s.* from student s join (
     select s_id from score group by s_id having count(c_id)<(select count(c_id) from course)
) b on s.s_id=b.s_id;
#12.查询至少有一门课与学号为"01"的同学所学相同的同学的信息(举一反三,这里可以找到至少有k门相同的同学信息)
select s.* from student s where s_id in(
	select s_id from score where s_id<>'01' and c_id in(
		select c_id from score where s_id='01')
	group by s_id having count(s_id)>=1
);
#13.查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.* from student s where s_id in(
	select s_id from score where s_id<>'01' and c_id in(
		select c_id from score where s_id='01')
	group by s_id having count(s_id)=(select count(c_id) from score where s_id='01')  #其实就是在上面的基础上进行改进的.
);
#14.查询没学过"张三"老师讲授的任一门课程的学生姓名(取反面情况)
select s_name from student where s_id not in (
select distinct s_id from score where c_id in (select c_id from course where t_id=(select t_id from teacher where t_name='张三'))
);
#15.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩(分组过滤)
select s.s_id,s.s_name,b.avg from student s join(
	select s_id,avg(s_score) as avg from score group by s_id having sum(case when s_score<=60 then 1 else 0 end)>=2
   ) b
on s.s_id=b.s_id;
#16.检索"01"课程分数小于60，按分数降序排列的学生信息
select s.* from student s join (
	select s_id from score where c_id='01' and s_score<=60 order by s_score desc
) b on s.s_id=b.s_id;
#17.按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select a.s_id,(select s_score from score where s_id=a.s_id and c_id='01') as 语文,
			  (select s_score from score where s_id=a.s_id and c_id='02') as 数学,
			  (select s_score from score where s_id=a.s_id and c_id='03') as 英语,
            round(avg(s_score),2) as 平均分 from score a  GROUP BY a.s_id ORDER BY 平均分 DESC;
#18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
select c_id,max(s_score),min(s_score),round(avg(s_score),2),
    sum(case when s_score>=60 then 1 else 0 end)/count(s_score) from score s group by c_id;
#19.按各科成绩进行排序，并显示排名 (排名场景是非常有效的)
select c_id,s_id,dense_rank() over (partition by c_id order by s_score) cnt from score order by c_id,cnt;
#20.查询学生的总成绩并进行排名
/*通过增加虚拟列来解决这个问题*/
select s_id,scores,rank() over(partition by total order by scores desc )as rk from(
	select s_id,sum(s_score) as scores,1 as total from score group by s_id
) b order by rk asc;
/*通过pl/sql中变量来定义*/
select s_id,scores,@i:=@i+1 as rk from (
   select s_id,sum(s_score) as scores from score group by s_id order by scores desc
) a,(select @i:=0) b;
#21.查询不同老师所教不同课程平均分从高到低显示 (多维度分组)
select t.t_id,t.t_name,s.c_id,avg(s.s_score) as avg from teacher t
  join course c on t.t_id=c.t_id join score s on c.c_id=s.c_id 
  group by s.c_id,t.t_id order by avg desc;
#22.查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
select s.*,b.c_id,b.s_score from student s join (
   select s_id,c_id,s_score,row_number() over(partition by c_id order by s_score desc) as cnt from score
) b on s.s_id=b.s_id where cnt between 2 and 3;
#23.统计各科成绩各分数段人数
select c_id,sum(case when s_score>=60 then 1 else 0 end)/count(s_score) as '及格率' from score group by c_id;
#24.查询学生平均成绩及其名次 
select s_id,avg,@i:=@i+1 from (
	select s_id,avg(s_score) as avg from score group by s_id order by avg desc
) a,(select @i:=0) b;
#25.查询各科成绩前三名的记录
select c_id,s_id,cnt from (
	select c_id,s_id,row_number() over(partition by c_id order by s_score desc) as cnt from score
) b where cnt<=3 order by c_id,cnt;
#26.查询每门课程被选修的学生数
select c_id,count(s_id)as '选修人数' from score group by c_id
union all
select c_id,0 from course where c_id not in (select distinct c_id from score);
#27.查询出只有两门课程的全部学生的学号和姓名
select s.s_id,s.s_name from(
	select s_id from score group by s_id having count(1)=2
) a join student s on a.s_id=s.s_id;
#28.查询男生、女生人数
select sum(case when s_sex='男' then 1 else 0 end) as '男生认数',
       sum(case when s_sex='女' then 1 else 0 end) as '女生人数' from student;
/*效率不高,不如第一种方案*/      
select s_sex,COUNT(s_sex) as 人数  from student GROUP BY s_sex order by null;    
#29.查询名字中含有"风"字的学生信息
select s_id from student where s_name like '%风%';
#30. 查询同名同性学生名单，并统计同名人数 
select s_name,count(1) as cnt from student group by s_name,s_sex having cnt>=2;
#31.查询1990年出生的学生名单
select s.* from student s where s_birth like '1992%';
#32.查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select c_id,ROUND(AVG(s_score),2) as avg_score from score GROUP BY c_id ORDER BY avg_score DESC,c_id ASC;
#33.查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
select a.s_id,b.s_name,ROUND(avg(a.s_score),2) as avg_score from score a
	left join student b on a.s_id=b.s_id GROUP BY s_id HAVING avg_score>=85;
#34.查询课程名称为"数学"，且分数低于60的学生姓名和分数 
select s.s_name,sc.s_score from student s,score sc 
  where s.s_id=sc.s_id and sc.c_id=(select c_id from course where c_name='数学');
#35.查询所有学生的课程及分数情况
select * from score;
#36.查询任何一门课程成绩在70分以上的姓名、课程名称和分数
select s.s_name,c.c_name,sc.s_score from score sc join student s
   on sc.s_id=s.s_id join course c on sc.c_id=c.c_id where sc.s_score>=70;
#37.查询不及格的课程
select s.s_name,c.c_name,sc.s_score from score sc join student s
   on sc.s_id=s.s_id join course c on sc.c_id=c.c_id where sc.s_score<60;
#38.查询课程编号为01且课程成绩在80分以上的学生的学号和姓名
select s.s_id,s.s_name from student s join score sc on s.s_id=sc.s_id where sc.c_id='01' and sc.s_score>=80;
#39.求每门课程的学生人数
select c_id,count(1) from score GROUP BY c_id;
#40.查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩
select a.c_id,s.s_id,s.s_name,a.s_score,rk from (
    #查询每门课程每个学生的排名
	select c_id,s_id,s_score,row_number() over(partition by c_id order by s_score desc) as rk from score
	 where c_id in(
		select c_id from course where t_id=(
			select t_id from teacher where t_name='张三'
										   )
				)
                              ) as a
join student s on a.s_id=s.s_id where rk=1;
#41.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
#42、查询每门功成绩最好的前两名

select c_id,s_id,s_score from(
	select c_id,s_id,s_score,row_number() over(partition by c_id order by s_score desc) as rk from score
) a where rk<=2 order by c_id,s_id,rk;
/*还有一种写法*/
select c_id,s_id,s_score from score s1 
   where (select count(1) from score s2 where s1.c_id=s2.c_id and s1.s_score<=s2.s_score)<=2 
   order by c_id,s_id;
#43.统计每门课程的学生选修人数（超过5人的课程才统计）。
#要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select c_id,count(s_id) as cnt from score group by c_id having cnt>5 order by c_id asc,cnt desc;
#44.检索至少选修两门课程的学生学号
select s_id from score group by s_id having count(c_id)>=2;
#45.查询选修了全部课程的学生信息
select s_id from score group by s_id having count(c_id)=(select count(1) from course);
#46.查询各学生的年龄
select s_id,s_birth,date_format(now(),'%Y')-date_format(s_birth,'%Y')-
   (case when date_format(now(),'%m%d')<date_format(s_birth,'%m%d') then 1 else 0 end) age from student;
#47.查询本周过生日的学生
select s_id from student where week(date_format(now(),'%y%m%d'))=week(s_birth);
#48.查询下周过生日的学生
select s_id from student where week(date_format(now(),'%y%m%d'))+1=week(s_birth);
#49.本月过生日的学生
select s_name from student where month(date_format(now(),'%y%m%d'))=month(s_birth);
#50.查询下月过生日的学生
select * from student where MONTH(DATE_FORMAT(NOW(),'%Y%m%d'))+1 =MONTH(s_birth);

