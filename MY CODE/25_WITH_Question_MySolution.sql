--1) WITH 절을 이용하여 정교수만 모여있는 가상테이블 하나와 일반과목(과목명에 일반이 포함되는)들이 모여있는 가상테이블 하나를 생성하여 
--   일반과목들을 강의하는 교수의 정보 조회하세요.(과목번호, 과목명, 교수번호, 교수이름)
WITH FULL_PROF AS(
	SELECT *
		FROM PROFESSOR P
		WHERE P.ORDERS='정교수'
), GENERAL_COURSE AS(
	SELECT *
		FROM COURSE C
		WHERE C.CNAME LIKE '%일반%'
)
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	FROM GENERAL_COURSE C
	JOIN FULL_PROF P
	  ON C.PNO = P.PNO;

--2) WITH 절을 이용하여 급여가 3000이상인 사원정보를 갖는 가상테이블 하나와 보너스가 500이상인 사원정보를 갖는 가상테이블 하나를 생성하여
--   두 테이블에 모두 속해있는 사원의 정보를 모두 조회하세요.
WITH SAL3000_EMP AS(
	SELECT *
		FROM EMP E
		WHERE E.SAL >= 3000
), COMM500_EMP AS(
	SELECT *
		FROM EMP E
		WHERE E.COMM >= 500
)
SELECT *
	FROM SAL3000_EMP SE
	FULL OUTER JOIN COMM500_EMP CE
	  ON SE.ENO = CE.ENO;
	 

--3) WITH 절을 이용하여 평점이 3.3이상인 학생의 목록을 갖는 가상테이블 하나와 학생별 기말고사 평균점수를 갖는 가상테이블 하나를 생성하여
--   평점이 3.3이상인 학생의 기말고사 평균 점수를 조회하세요.
WITH AVR_STUDENT AS(
	SELECT *
		FROM STUDENT ST
		WHERE ST.AVR >= 3.3
), AVG_SCORE AS(
	SELECT SC.SNO
		 , AVG(SC.RESULT) AS AVG_RES
		FROM SCORE SC
		GROUP BY SC.SNO
)	
SELECT ST.SNO
	 , ST.SNAME
	 , ST.AVR
	 , SC.AVG_RES
	FROM AVR_STUDENT ST
	JOIN AVG_SCORE SC
	  ON ST.SNO = SC.SNO;

--4) WITH 절을 이용하여 부임일자가 25년이상된 교수정보를 갖는 가상테이블 하나와 과목번호, 과목명, 학생번호, 학생이름, 교수번호, 기말고사성적을
--   갖는 가상테이블 하나를 생성하여 기말고사 성적이 90이상인 과목번호, 과목명, 학생번호, 학생이름, 교수번호, 교수이름, 기말고사성적을 조회하세요.
WITH HIRE25_PROF AS(
	SELECT *
		FROM PROFESSOR p 
		WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, P.HIREDATE)) >= 25 
), STU_INFO AS(
	SELECT C.CNO
		 , C.CNAME
		 , ST.SNO
		 , ST.SNAME
		 , C.PNO
		 , SC.RESULT
		FROM COURSE C
		JOIN SCORE SC
		  ON SC.CNO = C.CNO
		JOIN STUDENT ST
		  ON ST.SNO = SC.SNO
)
SELECT SI.CNO
	 , SI.CNAME
	 , SI.SNO
	 , SI.SNAME
	 , P.PNO
	 , P.PNAME
	 , SI.RESULT
	FROM STU_INFO SI
	JOIN HIRE25_PROF P
	  ON SI.PNO = P.PNO
	WHERE SI.RESULT >= 90;