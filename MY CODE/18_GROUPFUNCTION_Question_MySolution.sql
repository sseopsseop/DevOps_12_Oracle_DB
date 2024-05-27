--1) 화학과를 제외하고 학과별로 학생들의 평점 평균을 검색하세요
SELECT ST.MAJOR
	 , AVG(ST.AVR)
	FROM STUDENT ST
	WHERE ST.MAJOR != '화학'
	GROUP BY ST.MAJOR;

--2) 화학과를 제외한 각 학과별 평균 평점 중에 평점이 2.0 이상인 정보를 검색하세요
SELECT ST.MAJOR
	 , AVG(ST.AVR)
	FROM STUDENT ST
	WHERE ST.MAJOR != '화학'
	GROUP BY ST.MAJOR
	HAVING AVG(ST.AVR) >= 2.0;


--3) 기말고사 평균이 60점 이상인 학생의 정보를 검색하세요
SELECT ST.SNO
	 , ST.SNAME
	 , ST.SEX
	 , ST.SYEAR
	 , ST.MAJOR
	 , ST.AVR
	 , A."기말고사 평균"
	FROM STUDENT ST
	JOIN (
		SELECT ST.SNO
			 , AVG(SC."RESULT") AS "기말고사 평균"
			FROM STUDENT ST
			JOIN SCORE SC
			  ON ST.SNO = SC.SNO
			GROUP BY ST.SNO
			HAVING AVG(SC."RESULT") >= 60
	) A
	  ON ST.SNO = A.SNO;

--4) 강의 학점이 3학점 이상인 교수의 정보를 검색하세요
SELECT PNO
	 , P.PNAME
	 , P.SECTION
	 , P.ORDERS
	 , P.HIREDATE
	 , C.ST_NUM 
	FROM PROFESSOR p 
	NATURAL JOIN COURSE C
	WHERE C.ST_NUM >=3;

--5) 기말고사 평균 성적이 핵 화학과목보다 우수한 과목의 과목명과 담당 교수명을 검색하세요
SELECT C.CNAME 
	 , P.PNAME
	 , AVG(SC."RESULT")
	FROM COURSE C
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO
	JOIN SCORE SC
	  ON SC.CNO =C.CNO 
	GROUP BY C.CNAME, P.PNAME
	HAVING AVG(SC."RESULT") >= (
			SELECT AVG(SC."RESULT")
				FROM SCORE SC
				JOIN COURSE C
			  	  ON C.CNO = SC.CNO
				WHERE C.CNAME = '핵화학');
				
			  

--6) 근무 중인 직원이 4명 이상인 부서를 검색하세요(부서번호, 부서명, 인원수)
SELECT D.DNO
	 , D.DNAME
	 , COUNT(E.DNO)
	FROM DEPT D
	JOIN EMP E
	  ON D.DNO = E.DNO
	GROUP BY D.DNO, D.DNAME
	HAVING COUNT(E.DNO) >= 4; 

--7) 업무별 평균 연봉이 3000 이상인 업무를 검색하세요
SELECT E.JOB
	 , AVG(E.SAL)
	FROM EMP E
	GROUP BY E.JOB
	HAVING AVG(E.SAL) >=3000;
	

--8) 각 학과의 학년별 인원중 인원이 5명 이상인 학년을 검색하세요
SELECT ST.MAJOR 
	 , ST.SYEAR
	 , COUNT(*)
	FROM STUDENT ST
	GROUP BY ST.MAJOR, ST.SYEAR 
	HAVING COUNT(*)>= 5;
