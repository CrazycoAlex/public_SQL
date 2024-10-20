CREATE PROCEDURE etalon.xp_fill_report11(IN fWeek INT, IN in_sortmode INT)
  SQL SECURITY INVOKER
BEGIN

 SET @BeginDate = (SELECT
 wstart_date
 FROM nnz_weeks
 WHERE week_id = fweek);
 SET @year = COALESCE((SELECT
 sy.xp_key
 FROM school_year sy
 WHERE @BeginDate BETWEEN sy.BegDate AND sy.EndDate LIMIT 1), 0);


 DROP TABLE IF EXISTS nnz_w_instance;
 CREATE TEMPORARY TABLE IF NOT EXISTS nnz_w_instance (
 week_id int(11),
 wstart_date date,
 wend_date date,
 sh_var_id int(11),
 pers_sh_var_id int(11)
 );
 INSERT INTO nnz_w_instance (week_id, wstart_date, wend_date, sh_var_id, pers_sh_var_id)
 SELECT
 week_id,
 wstart_date,
 wend_date,
 sh_var_id,
 pers_sh_var_id
 FROM nnz_weeks
 WHERE week_id = fWeek;

 DROP TABLE IF EXISTS tmp_term_types;
 CREATE TEMPORARY TABLE tmp_term_types
 SELECT DISTINCT
 t.term_type_id
 FROM term_weeks tw
 INNER JOIN terms t
 ON (tw.trmid = t.trmid
 AND tw.week_id = fWeek);

 DROP TABLE IF EXISTS nnz_schedule_tmp;
 CREATE TEMPORARY TABLE IF NOT EXISTS nnz_schedule_tmp (
 week_id int(11),
 sh_var_id int(11) DEFAULT NULL,
 pers_sh_var_id int(11) DEFAULT NULL,
 rid int(11),
 period int(11),
 day_of_week int(11),
 teacher_mid int(11),
 cid int(11),
 gid int(11),
 ex tinyint(1),
 student varchar(255) DEFAULT NULL
 );
 INSERT INTO nnz_schedule_tmp (week_id, sh_var_id, rid, period, day_of_week, teacher_mid, cid, gid, ex)
 SELECT
 w.week_id,
 sh.sh_var_id,
 sh.rid,
 sh.period,
 sh.day_of_week,
 sh.teacher_mid,
 sh.cid,
 sh.gid,
 CASE WHEN COALESCE(sh.sheid, 0) > 0 THEN 1 ELSE 0 END ex
 FROM nnz_w_instance w
 INNER JOIN nnz_schedule sh
 ON sh.sh_var_id = w.sh_var_id
 WHERE IFNULL(sh.st_state_id, 0) <> 2
 AND EXISTS (SELECT
 1
 FROM tmp_term_types t
 WHERE t.term_type_id = xp_fget_group_term_type(sh.gid, @year));

 INSERT INTO nnz_schedule_tmp (week_id, pers_sh_var_id, rid, period, day_of_week, teacher_mid, cid, gid, ex, student)
 SELECT
 w.week_id,
 sh.sh_var_id AS pers_sh_var_id,
 sh.rid,
 sh.period,
 sh.day_of_week,
 IFNULL(sh.teacher1_mid, sh.teacher2_mid) AS teacher_mid,
 sh.cid,
 gu.gid,
 CASE WHEN COALESCE(sh.sheid, 0) > 0 THEN 1 ELSE 0 END ex,
 xp_f_get_mid_fio(sh.student_mid, 1) AS student
 FROM nnz_w_instance w
 INNER JOIN nnz_schedule_students sh
 ON sh.sh_var_id = w.pers_sh_var_id
 INNER JOIN groupuser gu
 ON gu.mid = sh.student_mid
 AND gu.cid = -1;

 DROP TABLE IF EXISTS report11;
 CREATE TEMPORARY TABLE IF NOT EXISTS report11
 SELECT
 EEE.day,
  getConst(CONCAT('Week.', day))  day_name,
 EEE.starttime,
 EEE.period_id,
 EEE.period_name,
 EEE.room_id,
 CASE in_sortmode
  WHEN 1 THEN
   CONCAT(
    IF (EEE.room_number REGEXP '^-?[0-9]+$',0,1),
    LPAD(EEE.room_number,5,'0'),
    EEE.room_name
    )
  WHEN 0 THEN
    CONCAT(  
      LPAD(' ',6,'0'),
      EEE.room_name
    )
  END AS room_name,
 EEE.room_number,
 CASE WHEN sh.student IS NULL THEN xp_fget_group_name(COALESCE(NULLIF(g.owner_gid, 0), g.gid), @year) ELSE CONCAT(sh.student, '(', xp_fget_group_name(COALESCE(NULLIF(g.owner_gid, 0), g.gid), @year), ')') END AS groupname,
 c.title coursename,
 ex,
 CONCAT(pt.LastName, ' ', SUBSTRING(pt.FirstName, 1, 1), '.', SUBSTRING(pt.Patronymic, 1, 1), '.') teacher,
 in_sortmode AS sortMode,
 IF (EEE.room_number REGEXP '^-?[0-9]+$',0,1) sortNums
 FROM (SELECT
 day,
 p.starttime,
 p.lid period_id,
 p.name period_name,
 r.rid room_id,
 r.name room_name,
 r.short_name room_number
 FROM (SELECT
 1 day
 UNION
 SELECT
 2 day
 UNION
 SELECT
 3 day
 UNION
 SELECT
 4 day
 UNION
 SELECT
 5 day
 UNION
 SELECT
 6 day) days,
 periods p,
 rooms r
 WHERE p.status = 1) EEE

 LEFT OUTER JOIN nnz_w_instance w
 ON 1 = 1
 LEFT OUTER JOIN nnz_schedule_tmp sh
 ON (sh.week_id = w.week_id
 AND (sh.sh_var_id = w.sh_var_id
 OR sh.pers_sh_var_id = w.pers_sh_var_id))
 AND sh.rid = EEE.room_id
 AND sh.period = EEE.period_id
 AND EEE.day = sh.day_of_week
 LEFT OUTER JOIN courses c
 ON sh.cid = c.cid
 LEFT OUTER JOIN groupname g
 ON sh.gid = g.gid
 LEFT OUTER JOIN people pt
 ON sh.teacher_mid = pt.mid
 WHERE CAST(DATE_ADD(w.wstart_date, INTERVAL (sh.day_of_week - 1 - WEEKDAY(w.wstart_date)) DAY) AS date) BETWEEN w.wstart_date AND w.wend_date
 GROUP BY EEE.day,
 EEE.period_id,
 EEE.period_name,
 EEE.room_id,
 EEE.room_name,
 EEE.room_number,
 ex;

 DROP TABLE IF EXISTS nnz_schedule_tmp;
END