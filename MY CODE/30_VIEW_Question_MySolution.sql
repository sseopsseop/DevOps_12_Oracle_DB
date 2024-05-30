--뷰 이름은 자유
--1) 학생의 평점 4.5 만점으로 환산된 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_STUDENT_CONVERT_AVR(
	STUDENT_NUM,
	STUDENT_NAME,
	STUDENT_CONVERT_AVR
)AS(
	SELECT ST.SNO
		 , ST.SNAME
		 , ST.AVR * 1.125
		FROM STUDENT ST
);

SELECT * FROM V_STUDENT_CONVERT_AVR;

--2) 각 과목별 기말고사 평균 점수를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_COURSE_AVG_SCORE(
	COURSE_NUM,
	COURSE_NAME,
	COURSE_AVG
)AS(
	SELECT C.CNO
		 , C.CNAME
		 , AVG(SC.RESULT) AS AVG_RES
		FROM COURSE C
		JOIN SCORE SC
		  ON SC.CNO = C.CNO
		GROUP BY C.CNO, C.CNAME
);

SELECT * FROM V_COURSE_AVG_SCORE;

--3) 각 사원과 관리자(MGR)의 이름을 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_EMP_MGR_NAME(
	EMPLOY_NUM,
	EMPLOY_NAME,
	MGR_NUM,
	MGR_NAME
)AS(
	SELECT E1.ENO
		 , E1.ENAME
		 , E2.ENO
		 , E2.ENAME
		FROM EMP E1
		JOIN EMP E2
		  ON E1.MGR = E2.ENO
);

SELECT * FROM V_EMP_MGR_NAME;

--4) 각 과목별 기말고사 평가 등급(A~F)까지와 해당 학생 정보를 검색할 수 있는 뷰를 생성하세요.
CREATE OR REPLACE VIEW V_COURSE_SCORE_GRADE_STUDENT(
	COURSE_NUM,
	COURSE_NAME,
	STUDENT_NUM,
	STUDENT_NAME,
	STUDENT_SCORE,
	STUDENT_GRADE
)AS(
	SELECT C.CNO
		 , C.CNAME
		 , ST.SNO
		 , ST.SNAME
		 , SC.RESULT
		 , SCG.GRADE
		FROM COURSE C
		JOIN SCORE SC
		  ON C.CNO = SC.CNO
		JOIN STUDENT ST
		  ON ST.SNO = SC.SNO
		JOIN SCGRADE SCG
		  ON SC.RESULT BETWEEN SCG.LOSCORE AND SCG.HISCORE
);
SELECT * FROM V_COURSE_SCORE_GRADE_STUDENT;

--5) 물리학과 교수의 과목을 수강하는 학생의 명단을 검색할 뷰를 생성하세요.
CREATE OR REPLACE VIEW PHY_PROF_COURSE_STUDENT(
	STUDENT_NUM,
	STUDENT_NAME,
	PROF_MAJOR,
	PROF_NUM,
	PROF_NAME,
	PROF_COURSE_NUM,
	PROF_COURSE_NAME
)AS(
	SELECT ST.SNO
		 , ST.SNAME
		 , P.SECTION
		 , P.PNO
		 , P.PNAME
		 , C.CNO
		 , C.CNAME
		FROM PROFESSOR P
		JOIN COURSE C
		  ON P.PNO = C.PNO
		JOIN SCORE SC
		  ON SC.CNO = C.CNO
		JOIN STUDENT ST
		  ON ST.SNO = SC.SNO
		WHERE P.SECTION ='물리'
);

SELECT * FROM PHY_PROF_COURSE_STUDENT;