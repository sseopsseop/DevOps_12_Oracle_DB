--<단일 행 함수를 이용하세요>
--1) 교수들이 부임한 달에 근무한 일수는 몇 일인지 검색하세요
SELECT P.PNAME
	 , P.HIREDATE
	 , LAST_DAY(P.HIREDATE) - P.HIREDATE  
	 FROM PROFESSOR p;
	 

--2) 교수들의 오늘까지 근무한 주가 몇 주인지 검색하세요
SELECT P.PNAME
	 , P.HIREDATE 
	 , ROUND((SYSDATE - P.HIREDATE) / 7, 0)
	FROM PROFESSOR p ;

--3) 1991년에서 1995년 사이에 부임한 교수를 검색하세요
SELECT P.PNAME
	 , P.HIREDATE
	FROM PROFESSOR p 
	WHERE P.HIREDATE 
		BETWEEN TO_DATE('1991-01-01', 'YYYY-MM-DD') 
			AND TO_DATE('1995-12-31', 'YYYY-MM-DD');

--4) 학생들의 4.5 환산 평점을 검색하세요(단 소수 이하 둘째자리까지)
SELECT ST.SNAME
	 , ROUND(ST.AVR * 1.125, 2)
	 FROM STUDENT ST
	 ORDER BY ST.AVR DESC;
	 

--5) 사원들의 오늘까지 근무 기간이 몇 년 몇 개월 며칠인지 검색하세요
SELECT E.ENO
	 , E.HDATE 
	 , MONTHS_BETWEEN(SYSDATE, E.HDATE)
	 , FLOOR(MONTHS_BETWEEN(SYSDATE, E.HDATE) / 12) || '년 '
	  || FLOOR(MOD(MONTHS_BETWEEN(SYSDATE, E.HDATE) , 12))
	  || ' 개월 '
	  || FLOOR(SYSDATE - ADD_MONTHS(E.HDATE, MONTHS_BETWEEN(SYSDATE, E.HDATE)))
	  || ' 일'
	FROM EMP E;

	