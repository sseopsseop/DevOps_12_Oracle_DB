-- 1. SUB QUARY
-- 1-1. 단일 행 서브쿼리
-- SELECT, FROM, JOIN, WHERE 절에서 사용가능한 서브쿼리
-- 송강교수보다 부임일자가 빠른 교수들의 교수번호, 교수이름 조회
SELECT PNO
	 , PNAME
	FROM PROFESSOR p
	WHERE HIREDATE < (
						SELECT HIREDATE
						FROM PROFESSOR P
						WHERE P.PNAME = '송강'
		);
		
-- 손하늘 사원보다 급여(연봉)가 높은 사원의 사원번호, 급여 조회
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	FROM EMP E
	WHERE E.SAL > (
					SELECT SAL
						FROM EMP
						WHERE ENAME = '손하늘');
						
-- 위 쿼리를 JOIN절로 변경
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 , A.SAL
	 FROM EMP E
	 JOIN(
	 	SELECT SAL
	 		FROM EMP
	 		WHERE ENAME = '손하늘'
	 		) A
	 ON E.SAL > A.SAL;
	
-- 공융의 일반화학 기말고사 성적보다 높은 학생의 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적 조회

SELECT ST.SNO
	 , ST.SNAME
	 , C.CNO
	 , C.CNAME 
	 , SC.RESULT
	FROM STUDENT ST
	JOIN SCORE SC
	 ON SC.SNO  = ST.SNO
	JOIN COURSE C
	 ON C.CNO = SC.CNO
	 AND C.CNAME ='일반화학'
	WHERE SC.RESULT > (
						SELECT SC.RESULT 
						FROM SCORE SC
						JOIN STUDENT ST
						 ON ST.SNO = SC.SNO
						JOIN COURSE C
						 ON C.CNO = SC.CNO
						WHERE ST.SNAME = '공융' AND C.CNAME ='일반화학');
					
					
-- 1-2. 다중행 서브쿼리
-- 서브쿼리의 결과가 에러행인 서브쿼리
-- FROM, JOIN, WHERE 절에서 사용 가능
-- 급여가 3000이상인 사원의 사원번호, 사원이름, 급여 조회
SELECT ENO, ENAME, SAL
	FROM EMP
	WHERE SAL >= 3000;

SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 FROM EMP E
	 JOIN (
	 SELECT ENO
	 	FROM EMP
	 	WHERE SAL>=3000) A
	 ON E.ENO = A.ENO;

-- WHERE 절에서 사용
SELECT E.ENO
	 , E.ENAME
	 , E.SAL
	 FROM EMP E
	 WHERE E.ENO IN (SELECT ENO
	 	FROM EMP
	 	WHERE SAL>=3000);

-- 1-3. 다중열 서브쿼리
-- 서브쿼리의 결과가 다중행이면서 다중열인 서브쿼리
-- FROM, JOIN 절에서만 사용가능
-- 과목번호, 과목이름, 교수번호, 교수이름을 조회하는 서브쿼리를 작성하여
-- 기말고사 성적 테이블과 조인하여 과목번호, 과목이름, 교수번호, 교수이름, 기말고사 성적을 조회
SELECT C.CNO
	 , C.CNAME
	 , P.PNO
	 , P.PNAME
	 , SC.RESULT
	FROM COURSE C
	JOIN SCORE SC
	  ON C.CNO = SC.CNO
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	 
SELECT A.CNO
	 , A.CNAME
	 , A.PNO
	 , A.PNAME
	 , SC.RESULT
	FROM (
		SELECT C.CNO
			 , C.CNAME
			 , P.PNO
			 , P.PNAME
			FROM COURSE C
			JOIN PROFESSOR P
			  ON C.PNO = P.PNO
	) A
	JOIN SCORE SC
	  ON A.CNO = SC.CNO;

-- 서브쿼리는 그룹함수와 주로 사용된다.
SELECT ST.SNO
	 , ST.SNAME
	 , AVG(SC.RESULT)
	FROM STUDENT ST
	JOIN SCORE SC
	  ON SC.SNO = ST.SNO
	GROUP BY ST.SNO, ST.SNAME;
	
-- 학생번호, 학생이름, 과목번호, 과목이름, 기말고사 성적, 기말고사 성적 등급, 담당 교수번호, 담당 교수이름 조회하는 데
-- STUDENT, SCORE, SCGRADE 테이블의 내용을 서브쿼리1
-- COURSE, PROFESSOR 테이블의 내용을 서브쿼리2

SELECT S1.SNO
	 , S1.SNAME
	 , S2.CNO
	 , S2.CNAME
	 , S1.RESULT
	 , S1.GRADE
	 , S2.PNO
	 , S2.PNAME
	FROM (
			SELECT ST.SNO
				 , ST.SNAME
				 , SCG.GRADE
				 , SC.RESULT
				 , SC.CNO
				FROM STUDENT ST
				JOIN SCORE SC
	  			  ON ST.SNO = SC.SNO 
				JOIN SCGRADE SCG
	  			  ON SC.RESULT BETWEEN SCG.LOSCORE AND SCG.HISCORE
	) S1
	JOIN (
			SELECT C.CNO
				 , C.CNAME
				 , P.PNO
				 , P.PNAME
				FROM COURSE C
				JOIN PROFESSOR P
	  			  ON C.PNO = P.PNO) S2
	  ON S1.CNO = S2.CNO;

SELECT *
	FROM STUDENT ST
	JOIN SCORE SC
	  ON ST.SNO = SC.SNO 
	JOIN SCGRADE SCG
	  ON SC.RESULT BETWEEN SCG.LOSCORE AND SCG.HISCORE; 
	  
SELECT *
	FROM COURSE C
	JOIN PROFESSOR P
	  ON C.PNO = P.PNO;
	  
-- 2. 집합연산자
-- 집합연산자는 서로 다른 두 쿼리의 결과를 합집합, 차집합, 교집합 해주는 연산자
-- 2-1. 합집합 연산자(UNION, UNION ALL)
-- 2000년 이후에 부임한 교수의 교수번호, 교수이름, 부임일자와 2000년 이후에 채용된 사원의 사원번호, 사원이름, 채용일자를 조회
-- 첫 번째 쿼리에서 컬럼의 개수, 데이터 타입이 결정되기 때문에 두 번째 쿼리는 첫 번째 쿼리의 컬럼의 개수, 데이터 타입을 따라야한다.
SELECT PNO
	 , PNAME
	 , HIREDATE
	FROM PROFESSOR
	WHERE HIREDATE >= TO_DATE('2000', 'YYYY')
UNION
SELECT ENO
	 , ENAME
	 , HDATE
	FROM EMP e 
	WHERE HDATE >= TO_DATE('2000', 'YYYY');

-- UNION은 중복을 제거해서 합집합 연산을 해준다.
-- 평점이 3.0 이상인 학생의 학생번호, 학생이름, 학년, 평점과 학년이 3학년의 학생의 학생번호, 학생이름, 학년, 평점을 함께 조회
-- 중복제거
SELECT ST.SNO 
	 , ST.SNAME
	 , ST.SYEAR 
	 , ST.AVR 
	FROM STUDENT ST
	WHERE ST.AVR >= 3.0
UNION
SELECT ST.SNO 
	 , ST.SNAME
	 , ST.SYEAR 
	 , ST.AVR 
	FROM STUDENT ST
	WHERE ST.SYEAR = 3
	ORDER BY SNO;

-- UNION은 중복을 제거해서 합집합 연산을 해준다.
-- 평점이 3.0 이상인 학생의 학생번호, 학생이름, 학년, 평점과 학년이 3학년의 학생의 학생번호, 학생이름, 학년, 평점을 함께 조회
-- 중복제거 없음
SELECT ST.SNO 
	 , ST.SNAME
	 , ST.SYEAR 
	 , ST.AVR 
	FROM STUDENT ST
	WHERE ST.AVR >= 3.0
UNION ALL
SELECT ST.SNO 
	 , ST.SNAME
	 , ST.SYEAR 
	 , ST.AVR 
	FROM STUDENT ST
	WHERE ST.SYEAR = 3
	ORDER BY SNO;

-- 2-2. 차집합 연산자(MINUS)
-- 첫 번째 쿼리에서 두 번째 쿼리와 공통된 데이터를 제외한 결과를 조회한다.
INSERT INTO EMP VALUES('9998', '제갈궁', '지원', NULL, SYSDATE, 3200, 320, NULL);
COMMIT;

-- 성이 제갈이면서 지원업무를 하지 않는 사원의 사원번호, 사원이름, 업무 조회
SELECT ENO
	 , ENAME
	 , JOB
	 FROM EMP
	 WHERE ENAME LIKE '제갈%'
	   AND JOB != '지원';
	
SELECT ENO
	 , ENAME
	 , JOB
	FROM EMP
	WHERE ENAME LIKE '제갈%'
MINUS
SELECT ENO
	 , ENAME
	 , JOB
	 FROM EMP
	 WHERE JOB ='지원';
	
-- 차집합 연산자를 사용해서 담당교수가 배정되지 않은 과목의 과목번호, 과목이름 조회
--SELECT C.CNO 
--	 , C.CNAME 
--	FROM COURSE C
--	LEFT OUTER JOIN PROFESSOR P
--	  ON P.PNO = C.PNO
--MINUS
--SELECT C.CNO 
--	 , C.CNAME 
--	FROM COURSE C
--	JOIN PROFESSOR P
--	  ON P.PNO = C.PNO
SELECT C.CNO 
	 , C.CNAME 
	FROM COURSE C
	WHERE 1=1
MINUS
SELECT C.CNO 
	 , C.CNAME 
	FROM COURSE C
	WHERE C.PNO IS NOT NULL

-- 2-3. 교집합 연산자(INTERSECT)
-- 첫 번째 쿼리의 결과에서 두 번째 퀴리의 공통된 결과만 조회
-- 교집합 연산자를 사용해서 물리, 화학과 학생중 평점 3.0 이상인 학생의 학생번호, 학생이름, 전공, 평점 조회
SELECT ST.SNO
	 , ST.SNAME
	 , ST.MAJOR
	 , ST.AVR
	FROM STUDENT ST
	WHERE ST.MAJOR IN ('물리', '화학')
INTERSECT 
SELECT ST.SNO
	 , ST.SNAME
	 , ST.MAJOR
	 , ST.AVR
	FROM STUDENT ST
	WHERE ST.AVR >= 3.0
	ORDER BY AVR DESC;

