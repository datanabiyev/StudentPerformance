-- Let's look at the raw data
-- Here is the description of the data we are looking for:
-- This dataset contains comprehensive information on 2,392 high school students, detailing their demographics, study habits, parental involvement, extracurricular activities, and academic performance. The target variable, GradeClass, classifies students' grades into distinct categories, providing a robust dataset for educational research, predictive modeling, and statistical analysis.

-- Table of Contents
-- Student Information:
-- Student ID
-- Demographic Details
-- Study Habits
-- Parental Involvement
-- Extracurricular Activities
-- Academic Performance
-- Target Variable: Grade Class
-- Student Information
-- Student ID
-- StudentID: A unique identifier assigned to each student (1001 to 3392).
-- Demographic Details
-- Age: The age of the students ranges from 15 to 18 years.
-- Gender: Gender of the students, where 0 represents Male and 1 represents Female.
-- Ethnicity: The ethnicity of the students, coded as follows:
-- 0: Caucasian
-- 1: African American
-- 2: Asian
-- 3: Other
-- ParentalEducation: The education level of the parents, coded as follows:
-- 0: None
-- 1: High School
-- 2: Some College
-- 3: Bachelor's
-- 4: Higher
-- Study Habits
-- StudyTimeWeekly: Weekly study time in hours, ranging from 0 to 20.
-- Absences: Number of absences during the school year, ranging from 0 to 30.
-- Tutoring: Tutoring status, where 0 indicates No and 1 indicates Yes.
-- Parental Involvement
-- ParentalSupport: The level of parental support, coded as follows:
-- 0: None
-- 1: Low
-- 2: Moderate
-- 3: High
-- 4: Very High
-- Extracurricular Activities
-- Extracurricular: Participation in extracurricular activities, where 0 indicates No and 1 indicates Yes.
-- Sports: Participation in sports, where 0 indicates No and 1 indicates Yes.
-- Music: Participation in music activities, where 0 indicates No and 1 indicates Yes.
-- Volunteering: Participation in volunteering, where 0 indicates No and 1 indicates Yes.
-- Academic Performance
-- GPA: Grade Point Average on a scale from 2.0 to 4.0, influenced by study habits, parental involvement, and extracurricular activities.
-- Target Variable: Grade Class
-- GradeClass: Classification of students' grades based on GPA:
-- 0: 'A' (GPA >= 3.5)
-- 1: 'B' (3.0 <= GPA < 3.5)
-- 2: 'C' (2.5 <= GPA < 3.0)
-- 3: 'D' (2.0 <= GPA < 2.5)
-- 4: 'F' (GPA < 2.0)

SELECT *
FROM [Student Performance]..[Student Performance]

-- (1) Let's check data for abnormalities in data points. For example, ParentalSupport must be in the range 0-4. 
-- If we encounter a data point, say 5, this data point would be considered as abnormal. We do tjis to make sure the data is clean
-- We check the data for abnormalities judging upon the data description provided above

SELECT * FROM [Student Performance]..[Student Performance] WHERE AGE > 18 OR AGE < 15 
SELECT * FROM [Student Performance]..[Student Performance] WHERE Gender > 1 OR Gender < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Ethnicity > 3 OR Ethnicity < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE ParentalEducation > 4 OR ParentalEducation < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE StudyTimeWeekly > 20 OR StudyTimeWeekly < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Absences > 30 OR Absences < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Tutoring > 1 OR Tutoring < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE ParentalSupport > 4 OR ParentalSupport < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Extracurricular > 1 OR Extracurricular < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Sports > 1 OR Sports < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Music > 1 OR Music < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE Volunteering > 1 OR Volunteering < 0
SELECT * FROM [Student Performance]..[Student Performance] WHERE GPA > 4 OR GPA < 0
SELECT *FROM [Student Performance]..[Student Performance]
WHERE 
    Age IS NULL OR
    Gender IS NULL OR
    Ethnicity IS NULL OR
    ParentalEducation IS NULL OR
    StudyTimeWeekly IS NULL OR
	Absences IS NULL OR
	Tutoring IS NULL OR
	ParentalSupport IS NULL OR
	Extracurricular IS NULL OR
	Sports IS NULL OR
	Music IS NULL OR
	Volunteering IS NULL OR
	GPA IS NULL OR
	GradeClass IS NULL
-- The queries above has given us empty rows, so we can be sure there are no abnormal data points!

-- (2) Let's check if there are certain column data types we might consider normalizing
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM 
    [INFORMATION_SCHEMA].[COLUMNS]
WHERE 
    TABLE_SCHEMA = 'dbo' AND 
    TABLE_NAME = 'Student Performance';
-- All column data points are of type float, so we good!
-- looks like our data is clean.

-- Let's dive in into the data exploration
-- (3) Let's look at the average StudyTimeWeekly and GPA of both genders
SELECT 
    Gender,
    AVG(GPA) AS AverageGPA,
    AVG(StudyTimeWeekly) AS AverageStudyTimeWeekly
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    Gender;
-- It turns out the gender in combination with StudyTimeWeekly does not closely determine the likelihood of high or low GPA
-- (4) What about Ethnicity?
SELECT 
    Ethnicity,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    Ethnicity
ORDER BY 1
-- Ok, the ethnicity of students does not seem to be correlated with high GPA as well
-- (5) Let's check parental education vs GPA
SELECT 
    ParentalEducation,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    ParentalEducation
ORDER BY 1
-- The same...
-- (6) Parental Support vs AVG GPA?
SELECT 
    ParentalSupport,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    ParentalSupport
ORDER BY 1
-- Yes! By looking at the results, we can see that the higher the ParentalSupport is, the higher GPA tends to be
-- (7) What about absences? I think the higher absence is, the lower is GPA
SELECT 
    Absences,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    Absences
ORDER BY 1
-- Yes, it is clear that by results that high absence counts tend to lead to lower GPA
-- (8)Let's check extracurricular vs GPA
SELECT 
    Extracurricular,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
    Extracurricular
ORDER BY 1
-- Contrary to my expectation, students with extracurriculars have higher avg GPA 
-- Let's check in combination Music and Sport and Volunteering vs GPA
SELECT 
    Music,
	Sports,	
	Volunteering,
    AVG(GPA) AS AverageGPA
FROM 
    [Student Performance]..[Student Performance]
GROUP BY 
	Music,
	Sports,	
	Volunteering
ORDER BY 1,2,3
-- Here are the reults:
-- M   S   V       AVG GPA
-- 0	0	0	1.83801544801758
-- 0	0	1	1.79301931356256
-- 0	1	0	1.96166684775378
-- 0	1	1	2.00015817619833
-- 1	0	0	1.9993343964053
-- 1	0	1	2.19176191712603
-- 1	1	0	2.08560758485153
-- 1	1	1	2.0081300573548

-- It looks like there are not much correlation, tendencies. 
-- Yet, we have to check that in Jupyter Notebook using pandas and numpy




 






