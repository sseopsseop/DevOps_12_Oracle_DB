--1) 각 학과별 학생 수를 검색하세요
SELECT ST.MAJOR
	 , COUNT(*) 
	FROM STUDENT ST
	GROUP BY ST.MAJOR;

--2) 화학과와 생물학과 학생 4.5 환산 평점의 평균을 각각 검색하세요
SELECT ST.MAJOR
	 , AVG(ST.AVR * 1.125)
	FROM STUDENT ST
	GROUP BY ST.MAJOR
	HAVING ST.MAJOR IN ('화학', '생물');

--3) 부임일이 10년 이상 된 직급별(정교수, 조교수, 부교수) 교수의 수를 검색하세요
SELECT P.ORDERS
	 , COUNT(*)
	FROM PROFESSOR P
	WHERE MONTHS_BETWEEN(SYSDATE, P.HIREDATE) / 12 >= 10 
	GROUP BY P.ORDERS
	


--4) 과목명에 화학이 포함된 과목의 학점수 총합을 검색하세요
SELECT SUM(C.ST_NUM)
	FROM COURSE C
	WHERE C.CNAME LIKE '%화학%';


--5) 학과별 기말고사 평균을 성적순(성적 내림차순)으로 검색하세요
SELECT ST.MAJOR 
	 , AVG(SC."RESULT")
	FROM SCORE SC
	JOIN COURSE C
	  ON C.CNO = SC.CNO 
	JOIN STUDENT ST
	  ON ST.SNO = SC.SNO
	GROUP BY ST.MAJOR;
	  
	  

--6) 30번 부서의 업무별 연봉의 평균을 검색하세요(소수점 두자리까지 표시)
SELECT E.JOB
	 , E.DNO 
	 , AVG(E.SAL)
	FROM EMP E
	GROUP BY E.JOB, E.DNO; 

SELECT D.DNO
	 , D.DNAME
	 , A.JOB
	 , ROUND(A.AVG_SAL, 2)
	FROM DEPT D
	JOIN (
		SELECT E.JOB
	 		 , E.DNO 
	 		 , AVG(E.SAL) AVG_SAL
			FROM EMP E
			GROUP BY E.JOB, E.DNO
	) A
	  ON D.DNO  = A.DNO
	WHERE D.DNO = 30;
	

--7) 물리학과 학생 중에 학년별로 성적이 가장 우수한 학생의 평점을 검색하세요(학과, 학년, 평점)
SELECT ST.MAJOR
	 , ST.SYEAR 
	 , MAX(ST.AVR)
	FROM STUDENT ST
	GROUP BY ST.MAJOR, ST.SYEAR 
	HAVING ST.MAJOR = '물리';